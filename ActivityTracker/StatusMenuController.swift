//
//  StatusMenuController.swift
//  ActivityTracker
//
//  Created by Cathal O Cuimin on 14/11/2016.
//  Copyright © 2016 Cathal O Cuimin. All rights reserved.
//

// sessionStart should be persisted in DB
import Cocoa
import CoreData
import AppKit

class StatusMenuController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }

    var sessionStart :Date?
    
    override func awakeFromNib() {
        var sessions = [NSManagedObject]()
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        listenForSleepWakeNotifications()
        if sessionStart == nil {
            sessionStart = Date()
        } else {
            print("Hmm... awakeFromNib was called but we already have a value for sessionStart")
        }
        print("Listening for sleep/wake notifications...")
        
        let appDelegate = NSApp.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            sessions = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        print("Sessions stored: \(sessions.count)")
        for s in sessions {
            print("Start: \(s.value(forKey: "startTime")!). End: \(s.value(forKey: "endTime")!)")
        }
        
        if sessionStart != nil {
            print("Current session started at: \(sessionStart!)")
        }

    }
    
    
    @objc private func receiveSleepNote(notification: NSNotification) {
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)


        print("\(hour):\(minutes):\(seconds) - Sleeping!");
        
        saveTime()
        
        
    }
    
    private func saveTime() {
        if sessionStart == nil {
            return
        }
        let appDelegate =
            NSApp.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "Session",
                                                 in:managedContext)
        
        let session = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        
        session.setValue(sessionStart, forKey: "startTime")
        session.setValue(Date(), forKey: "endTime")

        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        sessionStart = nil

    }
    
    @objc private func receiveWakeNote(notification: NSNotification) {
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        
        print("\(hour):\(minutes):\(seconds) - Awake!");
        
        sessionStart = Date()

    }
    
    private func listenForSleepWakeNotifications() {
        NSWorkspace.shared().notificationCenter.addObserver(
            self,
            selector: #selector(receiveSleepNote),
            name: NSNotification.Name.NSWorkspaceWillSleep,
            object: nil)
        
        NSWorkspace.shared().notificationCenter.addObserver(
            self,
            selector: #selector(receiveWakeNote),
            name: NSNotification.Name.NSWorkspaceDidWake,
            object: nil)
    }

}
