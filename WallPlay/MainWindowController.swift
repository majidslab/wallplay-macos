//
//  MainWindowController.swift
//
//  Created by Majid Jamali with ❤️ on 2/20/25.
//
//

import Cocoa
import AVFoundation
import SystemExtensions

final class MainWindowController: NSWindowController {
    
    var player: AVQueuePlayer?
    var looper: AVPlayerLooper?
    var layer: AVPlayerLayer?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        setupWindow()
        
        loadLastBackgroundVideo()
        
//        if let defaultUrl = Bundle.main.url(forResource: "default", withExtension: "mp4") {
//            defineMainView(defaultUrl)
//        }
    }
    
    func loadLastBackgroundVideo() {
        guard let lastVideo = UserDefaults.standard.value(forKey: "last") as? String,
              let url = URL(string: lastVideo) else { return }
        changeBackgroundVideoTo(url)
    }
    
    func saveLastLoadedVideo(_ url: URL) {
        UserDefaults.standard.set(url.absoluteString, forKey: "last")
    }
    
    func loadingImagesAndSetAsBackground() {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return
        }
        if let images = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
            
            for image in images {
                changeDesktopBackground(to: image)
            }
        }
    }
    
    func setupWindow() {
        // Make the title bar transparent
        self.window?.titlebarAppearsTransparent = true
        
        // Hide the title bar
        self.window?.styleMask.remove(.titled)
        
        // Optionally, remove the toolbar
        self.window?.toolbar?.isVisible = false
        
        self.window?.level = .normal
        self.window?.orderedIndex = -1000
        self.window?.isOpaque = false
        self.window?.backgroundColor = NSColor.clear
        self.window?.hasShadow = false
        self.window?.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAllowsTiling]
        // fullScreenAllowsTiling
        
        // Set the window size to match the screen dimensions
        if let screen = NSScreen.main {
            self.window?.setFrame(screen.frame, display: true)
        }
        
        if let window = self.window {
            window.styleMask = [.fullSizeContentView]
            window.isMovableByWindowBackground = false // Allow dragging the window by clicking anywhere
            window.standardWindowButton(.closeButton)?.isHidden = true // Hide close button
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true // Hide minimize button
            window.standardWindowButton(.zoomButton)?.isHidden = true // Hide zoom button
        }
    }
    
    func defineMainView(_ url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVQueuePlayer()
        looper = AVPlayerLooper(player: player!, templateItem: playerItem)
        
        layer = AVPlayerLayer(player: player)
        layer?.frame = self.window?.frame ?? .zero
        self.window?.contentView?.layer?.sublayers?.removeAll()
        self.window?.contentView?.layer?.addSublayer(layer!)
        
        layer?.videoGravity = .resizeAspectFill
        
        // Start playback
        player?.isMuted = true
        player?.play()
    }
    
    func changeBackgroundVideoTo(_ url: URL) {
        saveLastLoadedVideo(url)
        defineMainView(url)
    }
}
