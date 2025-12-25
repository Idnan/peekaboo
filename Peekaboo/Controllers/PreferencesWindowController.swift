import AppKit
import SwiftUI

class PreferencesWindowController: NSWindowController {
    convenience init() {
        let preferencesView = PreferencesView()
        let hostingController = NSHostingController(rootView: preferencesView)
        
        let window = NSWindow(contentViewController: hostingController)
        window.title = "Peekaboo Preferences"
        window.styleMask = [.titled, .closable]
        window.center()
        window.setFrameAutosaveName("PreferencesWindow")
        
        self.init(window: window)
    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        window?.center()
        window?.makeKeyAndOrderFront(nil)
    }
}
