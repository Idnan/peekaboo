import SwiftUI

struct HUDOverlayView: View {
    let isDesktopHidden: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isDesktopHidden ? "eye.slash.fill" : "eye.fill")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(isDesktopHidden ? "Shh... Desktop Hidden" : "Desktop Revealed!")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(isDesktopHidden ? "Your secrets are safe" : "Nothing to hide here")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            ZStack {
                if #available(macOS 12.0, *) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.8))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

// Preview for SwiftUI canvas
struct HUDOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HUDOverlayView(isDesktopHidden: true)
                .padding()
                .background(Color.gray)
                .previewDisplayName("Hidden")
            
            HUDOverlayView(isDesktopHidden: false)
                .padding()
                .background(Color.gray)
                .previewDisplayName("Visible")
        }
    }
}
