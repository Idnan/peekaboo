import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuBarController: MenuBarController?
    private var hudWindowController: HUDWindowController?
    private var preferencesWindowController: PreferencesWindowController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize managers
        DesktopManager.shared.syncWithSystemState()
        GlobalHotkeyManager.shared.registerHotkey()
        
        // Setup menu bar
        menuBarController = MenuBarController()
        menuBarController?.onToggle = { [weak self] in
            self?.toggleDesktop()
        }
        menuBarController?.onPreferences = { [weak self] in
            self?.showPreferences()
        }
        menuBarController?.onQuit = {
            NSApplication.shared.terminate(nil)
        }
        
        // Setup HUD
        hudWindowController = HUDWindowController()
        
        // Setup global hotkey callback
        GlobalHotkeyManager.shared.onHotkeyPressed = { [weak self] in
            self?.toggleDesktop()
        }
        
        // Update menu bar icon based on current state
        updateMenuBarIcon()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        GlobalHotkeyManager.shared.unregisterHotkey()
    }
    
    private func toggleDesktop() {
        let isHidden = DesktopManager.shared.toggleDesktopIcons()
        updateMenuBarIcon()
        hudWindowController?.show(isDesktopHidden: isHidden)
    }
    
    private func updateMenuBarIcon() {
        let isHidden = Settings.shared.isDesktopHidden
        menuBarController?.updateIcon(isDesktopHidden: isHidden)
    }
    
    private func showPreferences() {
        if preferencesWindowController == nil {
            preferencesWindowController = PreferencesWindowController()
        }
        preferencesWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
