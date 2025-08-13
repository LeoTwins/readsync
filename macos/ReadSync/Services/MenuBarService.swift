import SwiftUI

class MenuBarService: ObservableObject {
    private var statusItem: NSStatusItem?
    private var window: NSWindow?
    private var eventMonitor: Any?

    init() {
        setupMenuBar()
        setupWindow()
    }
    
    deinit {
        stopClickOutsideMonitoring()
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let statusButton = statusItem?.button {
            statusButton.image = NSImage(systemSymbolName: "doc.text", accessibilityDescription: nil)
            statusButton.action = #selector(statusBarButtonClicked)
            statusButton.target = self
        }
    }

    private func setupWindow() {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 320),
            styleMask: [.titled, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        // タイトルバーを透明にしてヘッダーを非表示
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        
        // ウィンドウボタンを非表示
        window?.standardWindowButton(.closeButton)?.isHidden = true
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window?.standardWindowButton(.zoomButton)?.isHidden = true
        
        // 角丸とシャドウを保持
        window?.isOpaque = false
        window?.hasShadow = true

        let hostingView = NSHostingView(rootView: URLInputView())
        hostingView.wantsLayer = true
        window?.contentView = hostingView
        window?.center()
    }

    @objc private func statusBarButtonClicked() {
        guard let window = window else { return }

        if window.isVisible {
            hideWindow()
        } else {
            showWindow()
        }
    }
    
    private func showWindow() {
        guard let window = window else { return }
        
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        startClickOutsideMonitoring()
    }
    
    private func hideWindow() {
        window?.orderOut(nil)
        stopClickOutsideMonitoring()
    }
    
    private func startClickOutsideMonitoring() {
        stopClickOutsideMonitoring()
        
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            guard let self = self, let window = self.window, window.isVisible else { return }
            
            let clickLocationInScreen = NSEvent.mouseLocation
            let windowFrame = window.frame
            
            if !windowFrame.contains(clickLocationInScreen) {
                self.hideWindow()
            }
        }
    }
    
    private func stopClickOutsideMonitoring() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
}