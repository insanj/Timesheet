//
//  TimesheetFriendRequest.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/12/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import Foundation

class TimesheetFriendRequest: NSObject {
    var json: [AnyHashable: Any]?
    var requestId: Int?
    var senderUser: TimesheetUser?
    var receiverUser: TimesheetUser?
    var accepted: Int?
    var created: Date?
    
    init(json: [AnyHashable: Any]) {
        self.json = json
        
        if let validId = json["id"] as? Int {
            requestId = validId
        }
        
        if let validJson = json["sender_user"] as? [AnyHashable: Any] {
            senderUser = TimesheetUser(json: validJson)
        }
        
        if let validJson = json["receiver_user"] as? [AnyHashable: Any] {
            receiverUser = TimesheetUser(json: validJson)
        }
        
        if let validAccepted = json["accepted"] as? Int {
            accepted = validAccepted
        }
        
        if let validCreated = json["created"] as? String {
            created = dateFromFormattedString(validCreated)
        }
    }
}
