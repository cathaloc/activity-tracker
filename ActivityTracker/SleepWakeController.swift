//
//  SleepWakeController.swift
//  ActivityTracker
//
//  Created by Cathal O Cuimin on 14/11/2016.
//  Copyright © 2016 Cathal O Cuimin. All rights reserved.
//

// TODO sessionStart should be persisted in DB
import Cocoa
import CoreData
import AppKit

class SleepWakeController: NSObject {
    
//    MARK: - Initializers
    
    override init() {
        super.init()
        listenForSleepWakeNotifications()
    }
    
    
//    MARK: - Notifications
    
    @objc private func receivedWakeNotification(notification: NSNotification) {
        logTime(message: "Waking!")
        SessionService.startNewSession()
    }
    
    @objc private func receivedSleepNotification(notification: NSNotification) {
        logTime(message: "Sleeping!")
        SessionService.finishExistingSession()
    }
    
//    MARK: - Notification Listener Setup
    
    private func listenForSleepWakeNotifications() {
        print("Now listening for sleep/wake notifications.")
        
        NSWorkspace.shared().notificationCenter.addObserver(
            self,
            selector: #selector(receivedSleepNotification),
            name: NSNotification.Name.NSWorkspaceWillSleep,
            object: nil)
        
        NSWorkspace.shared().notificationCenter.addObserver(
            self,
            selector: #selector(receivedWakeNotification),
            name: NSNotification.Name.NSWorkspaceDidWake,
            object: nil)

    }
    
    func stopListeningForSleepWakeNotifications() {
        print("No longer listening for sleep/wake notifications.")
        NSWorkspace.shared().notificationCenter.removeObserver(self)
    }
    
//    MARK: - Logging
    
    private func logTime(message :String) {
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        
        print("\(hour):\(minutes):\(seconds) - \(message)");
    }

}
