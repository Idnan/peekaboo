import Foundation

class Settings {
    static let shared = Settings()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let isDesktopHidden = "isDesktopHidden"
        static let keyboardShortcut = "keyboardShortcut"
        static let launchAtLogin = "launchAtLogin"
    }
    
    private init() {}
    
    var isDesktopHidden: Bool {
        get { defaults.bool(forKey: Keys.isDesktopHidden) }
        set { defaults.set(newValue, forKey: Keys.isDesktopHidden) }
    }
    
    var keyboardShortcut: KeyboardShortcutData {
        get {
            guard let data = defaults.data(forKey: Keys.keyboardShortcut),
                  let shortcut = try? JSONDecoder().decode(KeyboardShortcutData.self, from: data) else {
                return .defaultShortcut
            }
            return shortcut
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: Keys.keyboardShortcut)
            }
        }
    }
    
    var launchAtLogin: Bool {
        get { defaults.bool(forKey: Keys.launchAtLogin) }
        set {
            defaults.set(newValue, forKey: Keys.launchAtLogin)
            LaunchAtLoginManager.shared.setLaunchAtLogin(enabled: newValue)
        }
    }
}
