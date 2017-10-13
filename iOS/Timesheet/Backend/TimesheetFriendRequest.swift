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
    var senderUserId: Int?
    var receiverUserId: Int?
    var accepted: Int?
    var created: Date?
    
    init(json: [AnyHashable: Any]) {
        self.json = json
        
        if let validId = json["id"] as? Int {
            requestId = validId
        }
        
        if let validId = json["sender_user_id"] as? Int {
            senderUserId = validId
        }
        
        if let validId = json["receiver_user_id"] as? Int {
            receiverUserId = validId
        }
        
        if let validAccepted = json["accepted"] as? Int {
            accepted = validAccepted
        }
        
        if let validCreated = json["created"] as? String {
            created = dateFromFormattedString(validCreated)
        }
    }
}
