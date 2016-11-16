//
//  Session.swift
//  ActivityTracker
//
//  Created by Cathal O Cuimin on 15/11/2016.
//  Copyright © 2016 Cathal O Cuimin. All rights reserved.
//

import Foundation
import CoreData
import AppKit

class Session {
    
    // MARK: - Class Variables
    static let appDelegate = NSApp.delegate as! AppDelegate
    static let managedContext = appDelegate.managedObjectContext
    
    
    //MARK: - Initializers
    
    init() {
        
    }
    
    static func fetchAllSessions() {
        var sessions = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
        do {
            let results = try managedContext.fetch(fetchRequest)
            sessions = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}
