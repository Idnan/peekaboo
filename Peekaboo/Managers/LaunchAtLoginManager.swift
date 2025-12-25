import Foundation
import ServiceManagement

class LaunchAtLoginManager {
    static let shared = LaunchAtLoginManager()
    
    private init() {}
    
    func setLaunchAtLogin(enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to \(enabled ? "enable" : "disable") launch at login: \(error)")
            }
        } else {
            // Fallback for macOS 11-12
            let success = SMLoginItemSetEnabled("com.idnan.peekaboo" as CFString, enabled)
            if !success {
                print("Failed to \(enabled ? "enable" : "disable") launch at login (legacy)")
            }
        }
    }
    
    var isEnabled: Bool {
        if #available(macOS 13.0, *) {
            return SMAppService.mainApp.status == .enabled
        } else {
            // For older macOS, we rely on the stored preference
            return Settings.shared.launchAtLogin
        }
    }
}
