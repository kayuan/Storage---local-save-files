import UIKit
import os.log
let logGeneral = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "general")
let logTabOverview = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "tab-overview")
let logTabTypes = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "tab-types")
let logTabTypeDetail = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "tab-type-details")
let logTabFiles = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "tab-files")
let logUi = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "ui")
let logSettings = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "settings")
let logPurchase = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "purchase")
let logExtractSheet = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "extract-sheet")
struct UtiLookup {
    static var audio:     [String] = ["public.audio",
                                      "public.mp3",
                                      "public.mpeg-4-audio",
                                      "com.apple.protected-​mpeg-4-audio",
                                      "public.ulaw-audio",
                                      "public.aifc-audio",
                                      "public.aiff-audio",
                                      "com.apple.coreaudio-​format",
                                      "com.microsoft.waveform-​audio",
                                      "com.real.realaudio",
                                      "org.videolan.opus",
                                      "org.xiph.flac",
                                      "public.m3u-playlist",
                                      "com.apple.m4a-audio",
                                      "com.apple.protected-mpeg-4-audio"]
    static var videos:    [String] = ["public.movie",
                                      "public.video",
                                      "com.apple.quicktime-movie",
                                      "public.avi",
                                      "public.mpeg",
                                      "public.mpeg-4",
                                      "public.3gpp",
                                      "public.3gpp2",
                                      "com.microsoft.advanced-​systems-format",
                                      "com.real.realmedia",
                                      "org.matroska.mkv",
                                      "org.videolan.sub"]
    static var documents: [String] = ["public.html",
                                      "public.message",
                                      "public.presentation",
                                      "public.contact",
                                      "com.apple.ical.ics",
                                      "public.calendar-event",
                                      "public.plain-text",
                                      "public.rtf",
                                      "public.vcard",
                                      "com.apple.rtfd",
                                      "com.apple.flat-rtfd",
                                      "com.adobe.pdf",
                                      "com.adobe.postscript",
                                      "com.adobe.encapsulated-​postscript",
                                      "com.microsoft.word.doc",
                                      "com.microsoft.excel.xls",
                                      "com.microsoft.powerpoint.​ppt",
                                      "com.apple.keynote.key",
                                      "com.apple.keynote.kth",
                                      "net.daringfireball.markdown",
                                      "public.log",
                                      "org.openxmlformats.presentationml.presentation",
                                      "org.openxmlformats.spreadsheetml.sheet.macroenabled",
                                      "org.openxmlformats.spreadsheetml.sheet",
                                      "org.openxmlformats.wordprocessingml.document",
                                      "org.idpf.epub-container"]
    static var images:    [String] = ["public.image",
                                      "public.fax",
                                      "public.jpeg",
                                      "public.jpeg-2000",
                                      "public.tiff",
                                      "public.camera-raw-image",
                                      "com.apple.pict",
                                      "com.apple.macpaint-image",
                                      "public.png",
                                      "public.xbitmap-image",
                                      "com.apple.quicktime-image",
                                      "com.apple.icns",
                                      "com.adobe.photoshop-image",
                                      "com.adobe.illustrator.ai-​image",
                                      "com.compuserve.gif",
                                      "com.microsoft.bmp",
                                      "com.microsoft.ico",
                                      "com.truevision.tga-image",
                                      "com.ilm.openexr-image",
                                      "com.kodak.flashpix.image",
                                      "com.bohemiancoding.sketch.drawing",
                                      "public.svg-image"]
    static var code:      [String] = ["public.x509-certificate",
                                      "public.css",
                                      "public.xml",
                                      "public.json",
                                      "public.comma-separated-values-text",
                                      "public.source-code",
                                      "public.script",
                                      "public.shell-script",
                                      "public.perl-script",
                                      "public.python-script",
                                      "public.ruby-script",
                                      "public.php-script",
                                      "public.c-header",
                                      "public.c-source",
                                      "public.objective-c-source",
                                      "public.swift-source",
                                      "com.apple.applescript.text",
                                      "com.apple.applescript.script",
                                      "com.apple.generic-bundle",
                                      "com.apple.xcode.project",
                                      "com.apple.property-list",
                                      "com.apple.framework",
                                      "com.apple.dt.document.workspace",
                                      "com.apple.interfacebuilder.document.cocoa",
                                      "com.apple.dt.interfacebuilder.document.storyboard",
                                      "com.apple.mach-o-dylib",
                                      "com.netscape.javascript-source",
                                      "com.sun.java-class",
                                      "com.textasticapp.textastic.batch-file"]
    static var archives:  [String] = ["com.allume.stuffit-archive",
                                      "com.apple.application-bundle",
                                      "com.apple.binhex-archive",
                                      "com.apple.macbinary-​archive",
                                      "com.iosdec.aa.ipa",
                                      "com.pkware.zip-archive",
                                      "com.sun.java-archive",
                                      "org.7-zip.7-zip-archive",
                                      "org.gnu.gnu-tar-archive",
                                      "org.gnu.gnu-zip-archive",
                                      "org.gnu.gnu-zip-tar-archive",
                                      "org.tukaani.xz-archive",
                                      "public.archive",
                                      "public.bzip2-archive",
                                      "public.tar-archive",
                                      "public.zip-archive"]
    static var other:     [String] = ["public.folder",
                                      "public.data",
                                      "public.executable",
                                      "com.microsoft.windows-executable",
                                      "com.microsoft.windows-​dynamic-link-library",
                                      "public.url",
                                      "com.apple.web-internet-location",
                                      "com.microsoft.internet-shortcut",
                                      "com.apple.application",
                                      "public.font",
                                      "public.opentype-font",
                                      "public.truetype-ttf-font",
                                      "public.iso-image",
                                      "public.disk-image",
                                      "com.apple.disk-image"]
}
struct FileExtensionLookup {
    static var audio:     [String] = ["flac",
                                      "ogg",
                                      "opus",
                                      "spex"]
    static var videos:    [String] = []
    static var documents: [String] = ["db"]
    static var images:    [String] = ["sketch",
                                      "heif",
                                      "heic"]
    static var code:      [String] = ["entitlements",
                                      "xcodeproj",
                                      "xcworkspace",
                                      "xcworkspacedata",
                                      "xcuserstate",
                                      "xcuserdatad",
                                      "xcshareddata",
                                      "xcscheme",
                                      "storyboard",
                                      "cmake",
                                      "yaml",
                                      "bat",
                                      "map",
                                      "conf",
                                      "tcl",
                                      "so"]
    static var archives:  [String] = ["7z",
                                      "a",
                                      "ar",
                                      "apk",
                                      "cbr",
                                      "cbz",
                                      "ipa",
                                      "wsz",
                                      "xz"]
    static var other:     [String] = ["url"]
}
struct LocalizedTypeNames {
    static var audio = NSLocalizedString("type-audio", value: "Audio", comment: "Name of type")
    static var videos = NSLocalizedString("type-videos", value: "Videos", comment: "Name of type")
    static var documents = NSLocalizedString("type-documents", value: "Documents", comment: "Name of type")
    static var images = NSLocalizedString("type-images", value: "Images", comment: "Name of type")
    static var code = NSLocalizedString("type-code", value: "Code", comment: "Name of type")
    static var archives = NSLocalizedString("type-archives", value: "Archives", comment: "Name of type")
    static var other = NSLocalizedString("type-other", value: "Other", comment: "Name of type")
}
struct AppState {
    static var localFilesNumber: Int64 = 0
    static var localFoldersNumber: Int64 = 0
    static var localSizeBytes: Int64 = 0
    static var localSizeDiskBytes: Int64 = 0
    static var trashFilesNumber: Int64 = 0
    static var trashFoldersNumber: Int64 = 0
    static var trashSizeBytes: Int64 = 0
    static var trashSizeDiskBytes: Int64 = 0
    static var types: [TypeInfo] = [
        TypeInfo(name: LocalizedTypeNames.audio, color: UIColor(named: "ColorTypeAudio")!, size: 0, number: 0, paths: [], sizes: []),
        TypeInfo(name: LocalizedTypeNames.videos, color: UIColor(named: "ColorTypeVideos")!, size: 0, number: 0, paths: [], sizes: []),
        TypeInfo(name: LocalizedTypeNames.documents, color: UIColor(named: "ColorTypeDocuments")!, size: 0, number: 0, paths: [], sizes: []),
        TypeInfo(name: LocalizedTypeNames.images, color: UIColor(named: "ColorTypeImages")!, size: 0, number: 0, paths: [], sizes: []),
        TypeInfo(name: LocalizedTypeNames.code, color: UIColor(named: "ColorTypeCode")!, size: 0, number: 0, paths: [], sizes: []),
        TypeInfo(name: LocalizedTypeNames.archives, color: UIColor(named: "ColorTypeArchives")!, size: 0, number: 0, paths: [], sizes: []),
        TypeInfo(name: LocalizedTypeNames.other, color: UIColor(named: "ColorTypeOther")!, size: 0, number: 0, paths: [], sizes: [])
    ]
    struct files {
        static var allValues: [Double] = []
        static var fileInfos: [FileInfo] = []
    }
    static var documentsPath: String = ""
    static var updateInProgress: Bool = false
    static var demoContent: Bool = false  
    static var openUrlQuery: String! = ""
    static var openUrlScheme: String! = ""
}
struct TypeInfo {
    var name: String
    var color: UIColor
    var size: Int64
    var number: Int
    var paths: [String]
    var sizes: [Int64]
}
public struct FileInfo {
    var name: String
    var type: String
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let userDefaults = UserDefaults.standard
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        os_log("didFinishLaunchingWithOptions", log: logGeneral, type: .debug)
        ensureUserDefaults()
        AppState.documentsPath = FileManager.documentsDir()
        putPlaceholderFile(path: AppState.documentsPath)
        getStats()
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AppState.openUrlQuery = url.query
        AppState.openUrlScheme = url.scheme
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        os_log("applicationWillResignActive", log: logGeneral, type: .debug)
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        os_log("applicationDidEnterBackground", log: logGeneral, type: .debug)
        resetStats()
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        os_log("applicationWillEnterForeground", log: logGeneral, type: .debug)
        putPlaceholderFile(path: AppState.documentsPath)
        getStats()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        os_log("applicationDidBecomeActive", log: logGeneral, type: .debug)
        if AppState.openUrlScheme == "localstorage" {  
            if AppState.openUrlQuery.starts(with: "extract=") {  
                var path: String = AppState.openUrlQuery
                path = String(path.dropFirst(8))  
                path = path.removingPercentEncoding!  
                if path.count > 0 {
                    let archiveDict:[String: String] = ["path": path]
                    NotificationCenter.default.post(name: .launchFromShareExtension, object: nil, userInfo: archiveDict)
                }
            }
        }
        AppState.openUrlQuery = ""
        AppState.openUrlQuery = ""
    }
    func applicationWillTerminate(_ application: UIApplication) {
        os_log("applicationWillTerminate", log: logGeneral, type: .debug)
    }
}
