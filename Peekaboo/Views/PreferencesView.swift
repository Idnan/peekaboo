import SwiftUI

struct PreferencesView: View {
    @State private var shortcut: KeyboardShortcutData = Settings.shared.keyboardShortcut
    @State private var launchAtLogin: Bool = Settings.shared.launchAtLogin
    
    var body: some View {
        VStack(spacing: 0) {
            // Shortcut Row
            SettingsRow {
                HStack(spacing: 12) {
                    Label("Shortcut", systemImage: "command")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    HotkeyRecorderView(shortcut: $shortcut)
                }
            }
            
            // Reset link
            HStack {
                Spacer()
                Button("Reset to default") {
                    let defaultShortcut = KeyboardShortcutData.defaultShortcut
                    shortcut = defaultShortcut
                    Settings.shared.keyboardShortcut = defaultShortcut
                    GlobalHotkeyManager.shared.registerHotkey()
                }
                .buttonStyle(.plain)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .onHover { hovering in
                    if hovering {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            
            Divider()
                .padding(.horizontal, 16)
            
            // Launch at Login Row
            SettingsRow {
                HStack {
                    Label("Launch at Login", systemImage: "power")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Toggle("", isOn: $launchAtLogin)
                        .toggleStyle(.checkbox)
                        .labelsHidden()
                        .onChange(of: launchAtLogin) { newValue in
                            Settings.shared.launchAtLogin = newValue
                        }
                }
            }
        }
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(20)
        .frame(width: 340, height: 160)
    }
}

struct SettingsRow<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
