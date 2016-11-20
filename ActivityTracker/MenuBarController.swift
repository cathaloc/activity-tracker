//
//  MenuBarController.swift
//  ActivityTracker
//
//  Created by Cathal O Cuimin on 19/11/2016.
//  Copyright © 2016 Cathal O Cuimin. All rights reserved.
//

import Foundation

class MenuBarController : NSObject, NSMenuDelegate {
    
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    var currentSessionMenuItem : NSMenuItem?
    var previousSessionMenuItem : NSMenuItem?
    

    
//    MARK: - IB Actions

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    
//    MARK: - Setup
    
    override func awakeFromNib() {
        setupIcon()
        setupNotifications()
        self.statusMenu.delegate = self;
    }
    
    private func setupIcon() {
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    private func updateSessionDetails() {
        let existingSession = SessionService.findExistingSession()
        let prevSession = SessionService.findLastSession()
        
        if existingSession != nil {
            let curSessionDate = existingSession!.startTime!
            let currSessionTitle = "Session started \(curSessionDate.timeAgoSinceNow()!.lowercased())"
            
            if currentSessionMenuItem == nil {
                currentSessionMenuItem = NSMenuItem.init(title: currSessionTitle, action: nil, keyEquivalent: "")
                statusMenu.insertItem(currentSessionMenuItem!, at: 0)
            } else {
                currentSessionMenuItem!.title = currSessionTitle
            }
        }
        
        if prevSession != nil {
            let prevSessionTitle = "\(prevSession!.startTime!) -> \(prevSession!.endTime!)"
            
            if previousSessionMenuItem == nil {
                previousSessionMenuItem = NSMenuItem.init(title: prevSessionTitle, action: nil, keyEquivalent: "")
                statusMenu.insertItem(previousSessionMenuItem!, at: 1)
            } else {
                previousSessionMenuItem!.title = prevSessionTitle
            }
        }
        

    }
    
//    MARK: - Menu Delegate Methods
    
    func menuWillOpen(_ menu: NSMenu) {
        updateSessionDetails()
    }
    
//    MARK: - Notifications
    
    @objc private func mrReady(notification :NSNotification) {
        updateSessionDetails()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(mrReady),
            name: NSNotification.Name("MR_ready"),
            object: nil
        )

    }

    
}
