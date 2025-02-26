//
//  Scripts.swift
//
//  Created by Majid Jamali with ❤️ on 2/20/25.
//
//

import Cocoa
import AVFoundation

func changeDesktopBackgroundUsingShell(to imagePath: String) {
    // Construct the shell command
    let command = """
    defaults write com.apple.desktop Background '{default = {ImageFilePath = "\(imagePath)"; };}'
    killall Dock
    """
    
    // Execute the shell command
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", command]
    
    task.launch()
    task.waitUntilExit()
    
    if task.terminationStatus == 0 {
        print("Desktop background changed successfully!")
    } else {
        print("Failed to change desktop background.")
    }
}


func changeDesktopBackground(to url: URL) {
    do {
        if let screen = NSScreen.main {
            try NSWorkspace.shared.setDesktopImageURL(url, for: screen, options: [:])
        }
    } catch {
        print(error)
    }
}
