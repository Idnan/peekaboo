import AppKit

@main
struct PeekabooApp {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        
        // Ensure it's an accessory app (no dock icon, no main menu)
        app.setActivationPolicy(.accessory)
        
        app.run()
    }
}
