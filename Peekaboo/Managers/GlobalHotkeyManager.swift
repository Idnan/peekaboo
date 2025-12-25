import Carbon
import Foundation

class GlobalHotkeyManager {
    static let shared = GlobalHotkeyManager()
    
    private var hotkeyRef: EventHotKeyRef?
    private var eventHandler: EventHandlerRef?
    
    var onHotkeyPressed: (() -> Void)?
    
    private init() {}
    
    func registerHotkey() {
        unregisterHotkey()
        
        let shortcut = Settings.shared.keyboardShortcut
        
        // Install event handler if not already installed
        if eventHandler == nil {
            var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
            
            let status = InstallEventHandler(
                GetApplicationEventTarget(),
                { (_, event, userData) -> OSStatus in
                    guard let userData = userData else { return OSStatus(eventNotHandledErr) }
                    let manager = Unmanaged<GlobalHotkeyManager>.fromOpaque(userData).takeUnretainedValue()
                    manager.onHotkeyPressed?()
                    return noErr
                },
                1,
                &eventType,
                Unmanaged.passUnretained(self).toOpaque(),
                &eventHandler
            )
            
            if status != noErr {
                print("Failed to install event handler: \(status)")
                return
            }
        }
        
        // Register the hotkey
        var hotkeyID = EventHotKeyID(signature: OSType(0x5045454B), id: 1) // "PEEK"
        
        let status = RegisterEventHotKey(
            shortcut.keyCode,
            shortcut.modifiers,
            hotkeyID,
            GetApplicationEventTarget(),
            0,
            &hotkeyRef
        )
        
        if status != noErr {
            print("Failed to register hotkey: \(status)")
        }
    }
    
    func unregisterHotkey() {
        if let hotkeyRef = hotkeyRef {
            UnregisterEventHotKey(hotkeyRef)
            self.hotkeyRef = nil
        }
    }
    
    func updateHotkey(shortcut: KeyboardShortcutData) {
        Settings.shared.keyboardShortcut = shortcut
        registerHotkey()
    }
    
    deinit {
        unregisterHotkey()
        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
        }
    }
}
