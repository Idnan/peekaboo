import SwiftUI
import Carbon

struct HotkeyRecorderView: View {
    @Binding var shortcut: KeyboardShortcutData
    @State private var isRecording = false
    @State private var localMonitor: Any?
    
    var body: some View {
        Button(action: {
            startRecording()
        }) {
            Text(isRecording ? "Press shortcut..." : shortcut.displayString)
                .frame(minWidth: 120)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
        }
        .buttonStyle(.bordered)
        .foregroundColor(isRecording ? .secondary : .primary)
        .onDisappear {
            stopRecording()
        }
    }
    
    private func startRecording() {
        guard !isRecording else { return }
        isRecording = true
        
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            // Require at least one modifier
            let modifiers = event.modifierFlags.intersection([.command, .option, .control, .shift])
            guard !modifiers.isEmpty else { return event }
            
            // Ignore modifier-only key presses
            let keyCode = event.keyCode
            if keyCode == UInt16(kVK_Command) ||
               keyCode == UInt16(kVK_Shift) ||
               keyCode == UInt16(kVK_Option) ||
               keyCode == UInt16(kVK_Control) ||
               keyCode == UInt16(kVK_RightCommand) ||
               keyCode == UInt16(kVK_RightShift) ||
               keyCode == UInt16(kVK_RightOption) ||
               keyCode == UInt16(kVK_RightControl) {
                return event
            }
            
            let newShortcut = KeyboardShortcutData(
                keyCode: UInt32(keyCode),
                modifiers: modifiers.carbonFlags
            )
            
            DispatchQueue.main.async {
                shortcut = newShortcut
                GlobalHotkeyManager.shared.updateHotkey(shortcut: newShortcut)
                stopRecording()
            }
            
            return nil // Consume the event
        }
        
        // Also listen for Escape to cancel
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            if isRecording {
                stopRecording()
            }
        }
    }
    
    private func stopRecording() {
        if let monitor = localMonitor {
            NSEvent.removeMonitor(monitor)
            localMonitor = nil
        }
        isRecording = false
    }
}

struct HotkeyRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        HotkeyRecorderView(shortcut: .constant(.defaultShortcut))
            .padding()
    }
}
