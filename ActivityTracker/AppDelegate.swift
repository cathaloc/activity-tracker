//
//  AppDelegate.swift
//  ActivityTracker
//
//  Created by Cathal O Cuimin on 14/11/2016.
//  Copyright © 2016 Cathal O Cuimin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let swc = SleepWakeController.init()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        MagicalRecord.setupCoreDataStack()
        SessionService.startNewSession()
        
        NotificationCenter.default.post(name: NSNotification.Name("MR_ready"), object: nil)

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        SessionService.finishExistingSession()
        swc.stopListeningForSleepWakeNotifications()
    }

}

