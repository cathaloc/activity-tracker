//
//  MenuBarController.swift
//  ActivityTracker
//
//  Created by Cathal O Cuimin on 19/11/2016.
//  Copyright © 2016 Cathal O Cuimin. All rights reserved.
//

import Foundation

class MenuBarController : NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    
    override func awakeFromNib() {
        setupIcon()
        setupNotifications()
    }
    
    private func setupIcon() {
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    private func showPreviousSession() {
        let session = SessionService.findLastSession()
        if session == nil { return }
        
        let sessionString = "\(session!.startTime!) -> \(session!.endTime!)"
        
        let menuItem = NSMenuItem.init(title: sessionString, action: nil, keyEquivalent: "TODO")
        menuItem.isEnabled = true
        
        statusMenu.addItem(menuItem)
    }
    
    @objc private func mrReady(notification :NSNotification) {
        showPreviousSession()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.post(name: NSNotification.Name("MR_ready"), object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(mrReady),
            name: NSNotification.Name("MR_ready"),
            object: nil
        )

    }

    
}
