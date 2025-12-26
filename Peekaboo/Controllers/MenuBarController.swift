import AppKit
import Sparkle

class MenuBarController {
    private var statusItem: NSStatusItem?
    private var menu: NSMenu?
    
    var onToggle: (() -> Void)?
    var onPreferences: (() -> Void)?
    var onQuit: (() -> Void)?
    
    init() {
        setupStatusItem()
        setupMenu()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.title = "🐵"
            button.action = #selector(statusBarButtonClicked(_:))
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }
    
    private func setupMenu() {
        menu = NSMenu()
        
        let toggleItem = NSMenuItem(title: "Toggle Desktop Icons", action: #selector(toggleClicked), keyEquivalent: "")
        toggleItem.target = self
        menu?.addItem(toggleItem)
        
        menu?.addItem(NSMenuItem.separator())
        
        let preferencesItem = NSMenuItem(title: "Preferences...", action: #selector(preferencesClicked), keyEquivalent: ",")
        preferencesItem.target = self
        menu?.addItem(preferencesItem)
        
        let checkForUpdatesItem = NSMenuItem(title: "Check for Updates...", action: #selector(checkForUpdatesClicked), keyEquivalent: "")
        checkForUpdatesItem.target = self
        menu?.addItem(checkForUpdatesItem)
        
        menu?.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit Peekaboo", action: #selector(quitClicked), keyEquivalent: "q")
        quitItem.target = self
        menu?.addItem(quitItem)
    }
    
    @objc private func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .rightMouseUp {
            // Right click - show menu
            statusItem?.menu = menu
            statusItem?.button?.performClick(nil)
            statusItem?.menu = nil
        } else {
            // Left click - toggle
            onToggle?()
        }
    }
    
    @objc private func toggleClicked() {
        onToggle?()
    }
    
    @objc private func preferencesClicked() {
        onPreferences?()
    }
    
    @objc private func checkForUpdatesClicked() {
        UpdateManager.shared.checkForUpdates()
    }
    
    @objc private func quitClicked() {
        onQuit?()
    }
    
    func updateIcon(isDesktopHidden: Bool) {
        if let button = statusItem?.button {
            // 🙈 see no evil when hidden, 🐵 monkey face when visible
            button.title = isDesktopHidden ? "🙈" : "🐵"
            button.image = nil
        }
    }
}
