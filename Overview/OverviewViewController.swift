import UIKit
import os.log
class OverviewViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    @IBAction func onSettingsButton(_ sender: UIButton) {self.showSettings()}
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var localFilesLabel: UILabel!
    @IBOutlet weak var localFilesNumberLabel: UILabel!
    @IBOutlet weak var localFoldersLabel: UILabel!
    @IBOutlet weak var localFoldersNumberLabel: UILabel!
    @IBOutlet weak var localSizeLabel: UILabel!
    @IBOutlet weak var localSizeBytesLabel: UILabel!
    @IBOutlet weak var localSizeDiskLabel: UILabel!
    @IBOutlet weak var localSizeDiskBytesLabel: UILabel!
    @IBOutlet weak var localSizeFreeLabel: UILabel!
    @IBOutlet weak var localSizeFreeBytesLabel: UILabel!
    @IBOutlet weak var trashFilesLabel: UILabel!
    @IBOutlet weak var trashFilesNumberLabel: UILabel!
    @IBOutlet weak var trashFoldersLabel: UILabel!
    @IBOutlet weak var trashFoldersNumberLabel: UILabel!
    @IBOutlet weak var trashSizeLabel: UILabel!
    @IBOutlet weak var trashSizeBytesLabel: UILabel!
    @IBOutlet weak var trashSizeDiskLabel: UILabel!
    @IBOutlet weak var trashSizeDiskBytesLabel: UILabel!
    @IBOutlet weak var fileMgntStackView: UIStackView!
    @IBOutlet weak var reminderLineOneLabel: UILabel!
    @IBOutlet weak var reminderLineTwoLabel: UILabel!
    @IBOutlet weak var reminderLineThreeLabel: UILabel!
    @IBOutlet weak var reminderLineFourLabel: UILabel!
    @IBOutlet var refreshButton: UIButton!
    @IBAction func onRefreshButton() {self.refresh()}
    @IBOutlet var emptyTrashButton: UIButton!
    @IBAction func onEmptyTrashButton() {self.askEmptyTrash()}
    @IBAction func onFilesButton(_ sender: UIButton) {self.showFilesApp()}
    @IBAction func onPreferencesButton(_ sender: UIButton) {self.openPreferences()}
    override func viewDidLoad() {
        os_log("viewDidLoad", log: logTabOverview, type: .debug)
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(OverviewViewController.setTheme),
                                               name: .darkModeChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OverviewViewController.updatePending),
                                               name: .updatePending, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OverviewViewController.updateValues),
                                               name: .updateItemAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OverviewViewController.updateValues),
                                               name: .updateFinished, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OverviewViewController.updateFree),
                                               name: .updateFinished, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OverviewViewController.updateValues),
                                               name: .unitChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OverviewViewController.updateFree),
                                               name: .unitChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OverviewViewController.loadAppleFilesReminder),
                                               name: .showHelp, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OverviewViewController.showExtract),
                                               name: .launchFromShareExtension, object: nil)
        self.setTheme()
        self.loadAppleFilesReminder()
        if AppState.updateInProgress {
            self.updatePending()
        }
    }
    override func didReceiveMemoryWarning() {
        os_log("didReceiveMemoryWarning", log: logTabOverview, type: .debug)
        super.didReceiveMemoryWarning()
    }
    @objc func showExtract(_ notification: Notification) {
        os_log("showExtract", log: logTabOverview, type: .debug)
        guard let archivePath = notification.userInfo?["path"] as? String else { return }
        let sb = UIStoryboard(name: "Extract", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "ExtractNavController") as! ExtractNavController
        vc.setArchiveUrl(path: archivePath)
        vc.setReachedFromExtension()
        navigationController?.present(vc, animated: true, completion: nil)
    }
    @objc func loadAppleFilesReminder() {
        os_log("loadAppleFilesReminder", log: logTabOverview, type: .debug)
    }
    @objc func setTheme() {
        os_log("setTheme", log: logTabOverview, type: .debug)
        if userDefaults.bool(forKey: UserDefaultStruct.darkMode) {
            self.applyColors(fg: "ColorFontWhite", bg: "ColorBgBlack")
            self.navigationController?.navigationBar.barStyle = .black
        } else {
            self.applyColors(fg: "ColorFontBlack", bg: "ColorBgWhite")
            self.navigationController?.navigationBar.barStyle = .default
        }
    }
    func applyColors(fg: String, bg: String) {
        os_log("applyColors", log: logTabOverview, type: .debug)
        let fgColor: UIColor = UIColor(named: fg)!
        let bgColor: UIColor = UIColor(named: bg)!
        self.mainView.backgroundColor = bgColor
        self.localFilesLabel.textColor = fgColor
        self.localFilesNumberLabel.textColor = fgColor
        self.localFoldersLabel.textColor = fgColor
        self.localFoldersNumberLabel.textColor = fgColor
        self.localSizeLabel.textColor = fgColor
        self.localSizeBytesLabel.textColor = fgColor
        self.localSizeDiskLabel.textColor = fgColor
        self.localSizeDiskBytesLabel.textColor = fgColor
        self.localSizeFreeLabel.textColor = fgColor
        self.localSizeFreeBytesLabel.textColor = fgColor
        self.trashFilesLabel.textColor = fgColor
        self.trashFilesNumberLabel.textColor = fgColor
        self.trashFoldersLabel.textColor = fgColor
        self.trashFoldersNumberLabel.textColor = fgColor
        self.trashSizeLabel.textColor = fgColor
        self.trashSizeBytesLabel.textColor = fgColor
        self.trashSizeDiskLabel.textColor = fgColor
        self.trashSizeDiskBytesLabel.textColor = fgColor
        self.reminderLineOneLabel.textColor = fgColor
        self.reminderLineTwoLabel.textColor = fgColor
        self.reminderLineThreeLabel.textColor = fgColor
        self.reminderLineFourLabel.textColor = fgColor
    }
    func showSettings() {
        os_log("showSettings", log: logTabOverview, type: .debug)
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
        self.present(controller, animated: true, completion: nil)
    }
    func refresh() {
        os_log("refresh", log: logTabOverview, type: .debug)
        getStats()
    }
    func askEmptyTrash() {
        os_log("askEmptyTrash", log: logTabOverview, type: .debug)
        let alertTitle = NSLocalizedString("ask-empty-trash-title",
                                           value: "Are you sure you want to permanently erase all items in the Trash?",
                                           comment: "Title of alert")
        let alertMessage = NSLocalizedString("ask-empty-trash-message",
                                             value: "You can't undo this action",
                                             comment: "Message of alert")
        let alertCancel = NSLocalizedString("ask-empty-trash-cancel",
                                             value: "Cancel",
                                             comment: "Cancel button of alert")
        let alertOk = NSLocalizedString("ask-empty-trash-ok",
                                        value: "Empty Trash",
                                        comment: "Ok button of alert")
        if userDefaults.bool(forKey: UserDefaultStruct.askEmptyTrash) {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            let alertCancelAction = UIAlertAction(title: alertCancel, style: .`default`, handler: { _ in
                os_log("Alert action: Cancel", log: logUi, type: .debug)
            })
            let alertOkAction = UIAlertAction(title: alertOk, style: .`default`, handler: { _ in
                os_log("Alert action: Empty Trash", log: logUi, type: .debug)
                self.emptyTrash()
            })
            alert.addAction(alertCancelAction)
            alert.addAction(alertOkAction)
            alert.preferredAction = alertCancelAction
            self.present(alert, animated: true, completion: nil)
        } else {
            let appGroupName: String = "group.se.eberl.localstorage"
            if let destDirUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName) {
                clearDir(path: destDirUrl.path)
            }
            self.emptyTrash()
        }
    }
    func emptyTrash() {
        os_log("emptyTrash", log: logTabOverview, type: .debug)
        removeDir(path: FileManager.documentsDir() + "/" + ".Trash")
        getStats()
    }
    func showFilesApp() {
        os_log("showFilesApp", log: logTabOverview, type: .debug)
        openAppStore(id: 1232058109)
    }
    func openPreferences() {
        os_log("openPreferences", log: logTabOverview, type: .debug)
        let appPrefs: URL = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(appPrefs, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    @objc func updatePending() {
        os_log("updatePending", log: logTabOverview, type: .debug)
        self.localFilesNumberLabel.text   = "..."
        self.localFoldersNumberLabel.text = "..."
        self.localSizeBytesLabel.text     = "..."
        self.localSizeDiskBytesLabel.text = "..."
        if let bytes = getFreeSpace() {
            self.localSizeFreeBytesLabel.text = getSizeString(byteCount: bytes)
        }
        self.refreshButton.isEnabled = false
        self.trashFilesNumberLabel.text   = "..."
        self.trashFoldersNumberLabel.text = "..."
        self.trashSizeBytesLabel.text     = "..."
        self.trashSizeDiskBytesLabel.text = "..."
        self.emptyTrashButton.isEnabled = false
    }
    @objc func updateValues() {
        self.localFilesNumberLabel.text = String(AppState.localFilesNumber)
        self.localFoldersNumberLabel.text = String(AppState.localFoldersNumber)
        self.localSizeBytesLabel.text = getSizeString(byteCount: AppState.localSizeBytes)
        self.localSizeDiskBytesLabel.text = getSizeString(byteCount: AppState.localSizeDiskBytes)
        if AppState.updateInProgress {
            self.refreshButton.isEnabled = false
        } else {
            self.refreshButton.isEnabled = true
        }
        self.trashFilesNumberLabel.text   = String(AppState.trashFilesNumber)
        self.trashFoldersNumberLabel.text = String(AppState.trashFoldersNumber)
        self.trashSizeBytesLabel.text = getSizeString(byteCount: AppState.trashSizeBytes)
        self.trashSizeDiskBytesLabel.text = getSizeString(byteCount: AppState.trashSizeDiskBytes)
        if AppState.trashSizeDiskBytes == 0 || AppState.updateInProgress {
            self.emptyTrashButton.isEnabled = false
        } else {
            self.emptyTrashButton.isEnabled = true
        }
    }
    @objc func updateFree() {
        if let bytes = getFreeSpace() {
            self.localSizeFreeBytesLabel.text = getSizeString(byteCount: bytes)
        }
    }
}
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
