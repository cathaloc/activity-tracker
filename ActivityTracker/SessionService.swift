//
//  SessionService.swift
//  ActivityTracker
//
//  Created by Cathal O Cuimin on 19/11/2016.
//  Copyright © 2016 Cathal O Cuimin. All rights reserved.
//

/*
 * This is the only class that will perform Session CRUD operations, and saving/fetching them to/from the database
 */

import Foundation

class SessionService : NSObject {
    
    static var currentSession :NSDate? //will be used as a cache TODO
    
    static func startNewSession() {
        print("Creating new session")
        var session = findExistingSession()
        
        if session != nil {
            print("WARNING - Attempted to create a new session, but one already exists.")
            return
        }
        
        session = Session.mr_createEntity()
        session!.startTime = Date() as NSDate
        session!.isCurrent = true
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
    
    static func finishExistingSession() {
        print("Finishing session")
        let session = findExistingSession()
        
        if session == nil {
            print("WARNING - Attempted to finish a session, but none exists.")
            return
        }
        
        session!.endTime = Date() as NSDate
        session!.isCurrent = false
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
    
//    MARK: - Finders
    
    static func findExistingSession() -> Session? {
        let existingSessions = Session.mr_find(byAttribute: "isCurrent",
                                               withValue: true,
                                               andOrderBy: "startTime",
                                               ascending: false) as! [Session]
        
        warnIfMultipleSessions(sessions: existingSessions)
        
        if existingSessions.count < 1 {
            return nil
        }
        
        return existingSessions[0]
    }
    
    static func findLastSession() -> Session? {
        return Session.mr_findFirst(with: NSPredicate(
            format: "endTime != NULL AND isCurrent == false"),
            sortedBy: "endTime",
            ascending: false
        )
    }

    
//    MARK: - Logging
    
    static private func warnIfMultipleSessions(sessions: [Session]) {
        if(sessions.count > 1) {
            print("WARNING - Multiple current settings were found in the database.")
            for s in sessions {
                print("WARNING - \t Start: \(s.startTime), End: \(s.endTime), isCurrent: \(s.isCurrent)")
            }
        }
    }
    
    static private func printStackTrace() {
        for symbol: String in Thread.callStackSymbols {
            print(symbol)
        }
    }
    
}
