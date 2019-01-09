import UIKit
import os.log
import SWCompression  
class ExtractViewController: UIViewController {
    var archiveUrl: URL? = nil
    var reachedFromExtension: Bool = false
    var archiveType: String? = nil
    var archiveData: Data? = nil
    var targetDirUrl: URL? = nil
    let dirsBlacklist: [String] = ["/__MACOSX/"]
    let fileBlacklist: [String] = [".DS_Store"]
    @IBAction func onDoneButton(_ sender: UIBarButtonItem) { self.close() }
    @IBOutlet weak var archiveLabel: UILabel!
    @IBOutlet weak var compressionLabel: UILabel!
    @IBOutlet weak var compressionErrorLabel: UILabel!
    @IBOutlet weak var compressionDetailButton: UIButton!
    @IBAction func compressionDetailButton(_ sender: UIButton) { self.showCompressionDetail() }
    @IBOutlet weak var createFolderSwitch: UISwitch!
    @IBOutlet weak var deleteOnSuccessLabel: UILabel!
    @IBOutlet weak var deleteOnSuccessSwitch: UISwitch!
    @IBOutlet weak var leftPlaceholderLabel: UILabel!
    @IBOutlet weak var rightPlaceholderLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var extractButton: UIButton!
    @IBAction func extractButton(_ sender: UIButton) { self.extract() }
    override func viewDidLoad() {
        os_log("viewDidLoad", log: logExtractSheet, type: .debug)
        super.viewDidLoad()
        let parentVC = self.parent as! ExtractNavController
        self.archiveUrl = parentVC.archiveUrl
        self.reachedFromExtension = parentVC.reachedFromExtension
        self.compressionLabel.isHidden = true
        self.compressionErrorLabel.isHidden = false
        self.createFolderSwitch.isEnabled = false
        self.createFolderSwitch.setOn(false, animated: false)
        self.deleteOnSuccessSwitch.isEnabled = false
        self.deleteOnSuccessSwitch.setOn(false, animated: false)
        self.extractButton.isEnabled = false
        self.rightPlaceholderLabel.isHidden = false
        self.activityIndicator.isHidden = true
        if self.archiveUrl == nil {
            return
        }
        self.archiveLabel.text = self.archiveUrl!.lastPathComponent
        self.archiveType = self.getArchiveType()
        if self.archiveType != nil {
            self.compressionLabel.text = self.archiveType
            self.compressionLabel.isHidden = false
            self.compressionErrorLabel.isHidden = true
            self.compressionDetailButton.isHidden = true
            self.createFolderSwitch.isEnabled = true
            self.createFolderSwitch.setOn(true, animated: false)
            if self.reachedFromExtension == false {
                self.deleteOnSuccessSwitch.isEnabled = true
            }
            self.extractButton.isEnabled = true
        }
    }
    override func didReceiveMemoryWarning() {
        os_log("didReceiveMemoryWarning", log: logExtractSheet, type: .debug)
        super.didReceiveMemoryWarning()
    }
    func getArchiveType() -> String? {
        os_log("getArchiveType", log: logExtractSheet, type: .debug)
        if self.archiveUrl != nil {
            if let typeIdentifier = self.archiveUrl!.typeIdentifier {
                if ["public.zip-archive", "com.sun.java-archive", "com.iosdec.aa.ipa"].contains(typeIdentifier) {
                    return "zip"
                } else if typeIdentifier == "public.tar-archive" {
                    return "tar"
                } else if typeIdentifier == "org.7-zip.7-zip-archive" {
                    return "7zip"
                } else {
                    if typeIdentifier.starts(with: "dyn.") {
                        let fileExtension = self.archiveUrl!.pathExtension
                        if ["apk", "cbz", "ipa", "jar", "wsz", "zip"].contains(fileExtension) {
                            return "zip"
                        } else if ["tar"].contains(fileExtension) {
                            return "tar"
                        } else if ["7z"].contains(fileExtension) {
                            return "7zip"
                        }
                    }
                }
            }
        }
        return nil
    }
    func close() {
        os_log("close", log: logExtractSheet, type: .debug)
        self.dismiss(animated: true, completion: nil)
    }
    func showCompressionDetail() {
        os_log("showCompressionDetail", log: logExtractSheet, type: .debug)
        var typeInfoString = "???"
        if self.archiveUrl != nil {
            if let typeIdentifier = self.archiveUrl!.typeIdentifier {
                typeInfoString = typeIdentifier
            }
        }
        let compressionDetailErrorTitle = NSLocalizedString("compression-detail-error-title",
                                                            value: "Unsupported file type",
                                                            comment: "Title of alert")
        let compressionDetailErrorMessage = NSLocalizedString("compression-detail-error-message",
                                                              value: "Local Storage is only able to extract the types 'public.zip-archive', 'public.tar-archive' and 'org.7-zip.7-zip-archive'.\n\nYour file has the type '",
                                                              comment: "Shown on alert")
        let compressionDetailErrorOk = NSLocalizedString("compression-detail-error-ok",
                                                         value: "Ok",
                                                         comment: "Shown on alert")
        let alertController = UIAlertController(title: compressionDetailErrorTitle,
                                                message: compressionDetailErrorMessage + typeInfoString + "'.",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: compressionDetailErrorOk, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    func showExtractionError(detailedError: String?) {
        os_log("showExtractionError", log: logExtractSheet, type: .debug)
        let extractionErrorTitle = NSLocalizedString("extraction-error-title",
                                                     value: "Error during extraction",
                                                     comment: "Title of alert")
        let extractionErrorMessage = NSLocalizedString("extraction-error-message",
                                                       value: "The archive could not be extracted.",
                                                       comment: "Shown on alert")
        let extractionErrorOk = NSLocalizedString("extraction-error-ok",
                                                  value: "Ok",
                                                  comment: "Shown on alert")
        var detailedErrorString: String = " "
        if detailedError != nil {
            detailedErrorString += detailedError!
        }
        let alertController = UIAlertController(title: extractionErrorTitle,
                                                message: extractionErrorMessage + detailedErrorString,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: extractionErrorOk, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    func extract() {
        os_log("extract", log: logExtractSheet, type: .debug)
        var errorMsg: String? = nil
        let trashArchive: Bool = self.deleteOnSuccessSwitch.isOn  
        self.setExtractionPending()
        self.getTargetDir()
        DispatchQueue.global(qos: .userInitiated).async {
            if self.archiveUrl != nil {
                self.loadData()
            }
            if self.archiveType != nil && self.targetDirUrl != nil && self.archiveData != nil {
                if ["zip", "tar", "7zip"].contains(self.archiveType!) { errorMsg = self.openContainer() }
            }
            self.cleanUp(error: errorMsg, trashArchive: trashArchive)
            DispatchQueue.main.async {
                getStats()
                self.setExtractinFinished()
                if errorMsg == nil {
                    self.close()
                } else {
                    self.showExtractionError(detailedError: errorMsg)
                }
            }
        }
    }
    func setExtractionPending() {
        os_log("setExtractionPending", log: logExtractSheet, type: .debug)
        self.rightPlaceholderLabel.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.createFolderSwitch.isEnabled = false
        self.deleteOnSuccessSwitch.isEnabled = false
        self.extractButton.isEnabled = false
    }
    func setExtractinFinished() {
        os_log("setExtractinFinished", log: logExtractSheet, type: .debug)
        self.rightPlaceholderLabel.isHidden = false
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.createFolderSwitch.isEnabled = false
        if self.reachedFromExtension == false {
            self.deleteOnSuccessSwitch.isEnabled = true
        }
        self.extractButton.isEnabled = true
    }
    func getTargetDir() {
        os_log("getTargetDir", log: logExtractSheet, type: .debug)
        self.targetDirUrl = URL(fileURLWithPath: AppState.documentsPath, isDirectory: true)
        self.targetDirUrl?.appendPathComponent("Extracted")  
        if self.createFolderSwitch.isOn {
            self.targetDirUrl?.appendPathComponent(self.archiveUrl!.deletingPathExtension().lastPathComponent)
        }
    }
    func loadData() {
        os_log("loadData", log: logExtractSheet, type: .debug)
        do {
            self.archiveData = try Data(contentsOf: self.archiveUrl!)
        } catch let error {
            os_log("%@", log: logExtractSheet, type: .error, error.localizedDescription)
        }
    }
    func extractFile(filename: String, filedata: Data?) {
        os_log("Found file %@.", log: logExtractSheet, type: .debug, filename)
        let targetFileUrl = self.targetDirUrl!.appendingPathComponent(filename)
        if self.fileBlacklist.contains(targetFileUrl.lastPathComponent) {
            os_log("Skipping, filename is on blacklist.", log: logExtractSheet, type: .info)
            return
        }
        for dirBlacklist in self.dirsBlacklist {
            if targetFileUrl.path.range(of: dirBlacklist) != nil {
                os_log("Skipping, parent directory is on blacklist.", log: logExtractSheet, type: .info)
                return
            }
        }
        if filedata != nil {
            os_log("Writing data to %@.", log: logExtractSheet, type: .info, targetFileUrl.path)
            makeDirs(path: targetFileUrl.deletingLastPathComponent().path)
            do {
                try filedata!.write(to: targetFileUrl, options: Data.WritingOptions.atomic)
            }
            catch {
                os_log("%@", log: logExtractSheet, type: .error, error.localizedDescription)
            }
        } else {
            os_log("No data contained.", log: logExtractSheet, type: .error)
        }
    }
    func openContainer() -> String? {
        os_log("openContainer", log: logExtractSheet, type: .debug)
        do {
            if self.archiveType == "zip" {
                let zipContainer = try ZipContainer.open(container: self.archiveData!)
                for zipEntry in zipContainer {
                    if zipEntry.info.type == .regular {
                        self.extractFile(filename: zipEntry.info.name, filedata: zipEntry.data)
                    }
                }
            } else if self.archiveType == "tar" {
                let tarContainer = try TarContainer.open(container: self.archiveData!)
                for tarEntry in tarContainer {
                    if tarEntry.info.type == .regular {
                        self.extractFile(filename: tarEntry.info.name, filedata: tarEntry.data)
                    }
                }
            } else if self.archiveType == "7zip" {
                let sevenZipContainer = try SevenZipContainer.open(container: self.archiveData!)
                for sevenZipEntry in sevenZipContainer {
                    if sevenZipEntry.info.type == .regular {
                        self.extractFile(filename: sevenZipEntry.info.name, filedata: sevenZipEntry.data)
                    }
                }
            }
        } catch let error as ZipError {
            os_log("ZipError %@", log: logExtractSheet, type: .error, error.localizedDescription)
            return error.localizedDescription
        } catch let error as TarError {
            os_log("TarError %@", log: logExtractSheet, type: .error, error.localizedDescription)
            return error.localizedDescription
        } catch let error as SevenZipError {
            os_log("SevenZipError %@", log: logExtractSheet, type: .error, error.localizedDescription)
            return error.localizedDescription
        } catch let error {
            os_log("Error %@", log: logExtractSheet, type: .error, error.localizedDescription)
            return error.localizedDescription
        }
        return nil
    }
    func openCompression() -> String? {
        os_log("openCompression", log: logExtractSheet, type: .debug)
        do {
            if self.archiveType == "bzip2" {
                let decompressedData = try BZip2.decompress(data: self.archiveData!)
                let filename: String = self.archiveUrl!.deletingPathExtension().lastPathComponent
                self.extractFile(filename: filename, filedata: decompressedData)
            } else if self.archiveType == "xz" {
                let decompressedData = try XZArchive.unarchive(archive: self.archiveData!)
                let filename: String = self.archiveUrl!.deletingPathExtension().lastPathComponent
                self.extractFile(filename: filename, filedata: decompressedData)
            } else if self.archiveType == "gzip" {
                let decompressedData = try GzipArchive.unarchive(archive: self.archiveData!)
                let filename: String = self.archiveUrl!.deletingPathExtension().lastPathComponent
                self.extractFile(filename: filename, filedata: decompressedData)
            }
        } catch let error as BZip2Error {
            os_log("BZip2Error %@", log: logExtractSheet, type: .error, error.localizedDescription)
            return error.localizedDescription
        } catch let error as XZError {
            os_log("XZError %@", log: logExtractSheet, type: .error, error.localizedDescription)
            return error.localizedDescription
        } catch let error as GzipError {
            os_log("GzipError %@", log: logExtractSheet, type: .error, error.localizedDescription)
            return error.localizedDescription
        } catch let error {
            os_log("Error %@", log: logExtractSheet, type: .error, error.localizedDescription)
            return error.localizedDescription
        }
        return nil
    }
    func cleanUp(error: String?, trashArchive: Bool) {
        os_log("cleanUp", log: logExtractSheet, type: .debug)
        if error == nil && trashArchive == true {
            trashFileIfExist(path: self.archiveUrl!.path)
        }
        let appGroupName: String = "group.se.eberl.localstorage"
        if let destDirUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName) {
            clearDir(path: destDirUrl.path)
        }
    }
    func loadCacheFix()
    {
        print("this is app")
    }
}
