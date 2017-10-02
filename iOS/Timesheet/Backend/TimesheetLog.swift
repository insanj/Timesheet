//
//  TimesheetLog.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/1/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import Foundation

class TimesheetLog: NSObject {
    var logId: Int?
    var userId: Int?
    var timeIn: Date?
    var timeOut: Date?
    var notes: String?
    var created: Date?
    
    init(json: [AnyHashable: Any]) {
        if let validId = json["id"] as? Int {
            logId = validId
        }
        
        if let validUserId = json["user_id"] as? Int {
            userId = validUserId
        }
        
        if let validTimeIn = json["time_in"] as? String {
            timeIn = dateFromFormattedString(validTimeIn)
        }
        
        if let validTimeOut = json["time_out"] as? String {
            timeOut = dateFromFormattedString(validTimeOut)
        }
        
        if let validNotes = json["notes"] as? String {
            notes = validNotes
        }
        
        if let validCreated = json["created"] as? String {
            created = dateFromFormattedString(validCreated)
        }
        
        super.init()
    }
}
