import Foundation
import os.log
struct UserDefaultStruct {
    static var darkMode: String = "darkMode"
    static var darkModeDefault: Bool = false
    static var unit: String = "unit"
    static var unitDefault: String = "all"  
    static var askEmptyTrash: String = "askEmptyTrash"
    static var askEmptyTrashDefault: Bool = true
    static var showHelp: String = "showHelp"
    static var showHelpDefault: Bool = true
    static var animateUpdateDuringRefresh: String = "animateUpdateDuringRefresh"
    static var animateUpdateDuringRefreshDefault: Bool = true
}
func isKeyPresentInUserDefaults(key: String) -> Bool {
    if UserDefaults.standard.object(forKey: key) == nil {
        return false
    } else {
        return true
    }
}
func ensureUserDefaults() {
    os_log("ensureUserDefaults", log: logGeneral, type: .debug)
    let userDefaults = UserDefaults.standard
    if !isKeyPresentInUserDefaults(key: UserDefaultStruct.darkMode) {
        userDefaults.set(UserDefaultStruct.darkModeDefault, forKey: UserDefaultStruct.darkMode)
    }
    if !isKeyPresentInUserDefaults(key: UserDefaultStruct.unit) {
        userDefaults.set(UserDefaultStruct.unitDefault, forKey: UserDefaultStruct.unit)
    }
    if !isKeyPresentInUserDefaults(key: UserDefaultStruct.askEmptyTrash) {
        userDefaults.set(UserDefaultStruct.askEmptyTrashDefault, forKey: UserDefaultStruct.askEmptyTrash)
    }
    if !isKeyPresentInUserDefaults(key: UserDefaultStruct.showHelp) {
        userDefaults.set(UserDefaultStruct.showHelpDefault, forKey: UserDefaultStruct.showHelp)
    }
    if !isKeyPresentInUserDefaults(key: UserDefaultStruct.animateUpdateDuringRefresh) {
        userDefaults.set(UserDefaultStruct.animateUpdateDuringRefreshDefault, forKey: UserDefaultStruct.animateUpdateDuringRefresh)
    }
}
