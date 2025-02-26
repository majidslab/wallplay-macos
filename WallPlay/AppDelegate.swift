//
//  AppDelegate.swift
//
//  Created by Majid Jamali with ❤️ on 2/26/25.
//  
//  

import Cocoa
import AVFoundation

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBarItem: NSStatusItem?
    private var number = 0.0
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        defineStatusBarView()
        animateStatuBarIcon()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}


extension AppDelegate {
    
    func animateStatuBarIcon() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] t in
            guard let windowController = NSApplication.shared.windows.first?.windowController as? MainWindowController else { return }
            if windowController.looper?.status == .ready {
                if self?.number ?? 0 <= 2 {
                    self?.number += 1
                } else {
                    self?.number = 0
                }
                if let button = self?.statusBarItem?.button {
                    let number = self?.number ?? 0
                    let image = NSImage(systemSymbolName: "square.stack.3d.up.fill", variableValue: number / 3.0, accessibilityDescription: "Status Bar Icon")
                    button.image = image
                } else {
                    t.invalidate()
                }
            }
        }.fire()
    }
    
    func defineStatusBarView() {
        let statusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusBarItem = statusBar
        if let button = statusBar.button {
            let image = NSImage(systemSymbolName: "square.stack.3d.up", variableValue: 0.0, accessibilityDescription: "Status Bar Icon")
            button.image = image
            button.action = #selector(statusBarClicked)
        }
        
        // Create a menu for the status bar item
        let menu = NSMenu()
        
        // Add menu items
        menu.addItem(NSMenuItem(title: "Show Preferences", action: #selector(showPreferences), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Open video from file", action: #selector(changeBackground), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Open image from file", action: #selector(changeBackgroundImage), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: ""))
        
        // Assign the menu to the status bar item
        statusBar.menu = menu
    }
    
    @objc func changeBackgroundImage() {
        let dialog = NSOpenPanel()
        dialog.title = "Choose an image file"
        dialog.allowedContentTypes = [.image]
        dialog.allowsMultipleSelection = false

        if dialog.runModal() == .OK {
            if let url = dialog.urls.first {
                changeDesktopBackground(to: url)
            }
        }
    }
    
    @objc func changeBackground() {
        let dialog = NSOpenPanel()
        dialog.title = "Choose a video file"
        dialog.allowedContentTypes = [.movie]
        dialog.allowsMultipleSelection = false

        if dialog.runModal() == .OK {
            if let url = dialog.urls.first {
                guard let windowController = NSApplication.shared.windows.first?.windowController as? MainWindowController else { return }
                windowController.changeBackgroundVideoTo(url)
//                changeDesktopBackground(to: url)
                
            }
        }
    }
    
    @objc func statusBarClicked() {
       print("Status bar item clicked!")
       // You can show a menu or perform other actions here
   }
    
    @objc func showPreferences() {
        print("Show preferences...")
        // Implement your preferences logic here
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(self)
    }
}

