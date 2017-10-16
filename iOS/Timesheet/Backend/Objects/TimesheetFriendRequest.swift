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
        
        if let validJson = json["sender_user"] as? String, let data = validJson.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let array = json as? [[AnyHashable: Any]], let user = array.first {
                    senderUser = TimesheetUser(json: user)
                }
            }
            catch {
                debugPrint("TimesheetFriendRequest unable to JSONSerialization sender_user")
            }
        }
        
        if let validJson = json["receiver_user"] as? String, let data = validJson.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let array = json as? [[AnyHashable: Any]], let user = array.first {
                    receiverUser = TimesheetUser(json: user)
                }
            }
            catch {
                debugPrint("TimesheetFriendRequest unable to JSONSerialization receiver_user")
            }
        }
        
        if let validAccepted = json["accepted"] as? Int {
            accepted = validAccepted
        }
        
        if let validCreated = json["created"] as? String {
            created = dateFromFormattedString(validCreated)
        }
    }
}
