import Foundation

class DesktopManager {
    static let shared = DesktopManager()
    
    private init() {}
    
    /// Syncs the app's state with the actual system state on launch
    func syncWithSystemState() {
        let isVisible = readCreateDesktopValue()
        Settings.shared.isDesktopHidden = !isVisible
    }
    
    /// Reads the current CreateDesktop value from Finder preferences
    private func readCreateDesktopValue() -> Bool {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/defaults")
        task.arguments = ["read", "com.apple.finder", "CreateDesktop"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
                return output == "1" || output == "true"
            }
        } catch {
            print("Error reading CreateDesktop: \(error)")
        }
        
        // Default to visible
        return true
    }
    
    /// Toggles desktop icons visibility
    /// Returns true if desktop is now hidden, false if visible
    @discardableResult
    func toggleDesktopIcons() -> Bool {
        let shouldHide = !Settings.shared.isDesktopHidden
        setDesktopIconsHidden(shouldHide)
        return shouldHide
    }
    
    /// Sets desktop icons visibility
    func setDesktopIconsHidden(_ hidden: Bool) {
        let value = hidden ? "FALSE" : "TRUE"
        
        // Write the preference
        let writeTask = Process()
        writeTask.executableURL = URL(fileURLWithPath: "/usr/bin/defaults")
        writeTask.arguments = ["write", "com.apple.finder", "CreateDesktop", value]
        
        do {
            try writeTask.run()
            writeTask.waitUntilExit()
            
            // Restart Finder to apply
            let killTask = Process()
            killTask.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
            killTask.arguments = ["Finder"]
            try killTask.run()
            killTask.waitUntilExit()
            
            Settings.shared.isDesktopHidden = hidden
        } catch {
            print("Error setting CreateDesktop: \(error)")
        }
    }
}
