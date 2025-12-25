import AppKit
import SwiftUI

class HUDWindowController: NSWindowController {
    private var dismissTimer: Timer?
    private var fadeTimer: Timer?
    
    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 280, height: 70),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        window.isMovableByWindowBackground = false
        window.hasShadow = false
        
        self.init(window: window)
    }
    
    func show(isDesktopHidden: Bool) {
        guard let window = window, let screen = NSScreen.main else { return }
        
        // Cancel any existing timers
        dismissTimer?.invalidate()
        fadeTimer?.invalidate()
        
        // Update content
        let hudView = HUDOverlayView(isDesktopHidden: isDesktopHidden)
        window.contentView = NSHostingView(rootView: hudView)
        
        // Position in top-right corner with padding
        let padding: CGFloat = 20
        let screenFrame = screen.visibleFrame
        let windowSize = window.frame.size
        
        let x = screenFrame.maxX - windowSize.width - padding
        let y = screenFrame.maxY - windowSize.height - padding
        
        window.setFrameOrigin(NSPoint(x: x, y: y))
        
        // Reset alpha and show
        window.alphaValue = 0
        window.orderFrontRegardless()
        
        // Fade in
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            window.animator().alphaValue = 1
        }
        
        // Auto-dismiss after 2 seconds
        dismissTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            self?.dismiss()
        }
    }
    
    private func dismiss() {
        guard let window = window else { return }
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            window.animator().alphaValue = 0
        }, completionHandler: { [weak self] in
            self?.window?.orderOut(nil)
        })
    }
}
