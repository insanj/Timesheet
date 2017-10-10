//
//  TimesheetUser.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/9/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import Foundation

class TimesheetUser: NSObject {
    var json: [AnyHashable: Any]?
    var userId: Int?
    var name: String?
    var created: Date?
    var email: String?
    
    init(json: [AnyHashable: Any]) {
        self.json = json
        
        if let validId = json["id"] as? Int {
            userId = validId
        }
        
        if let validName = json["name"] as? String {
            name = validName
        }
        
        if let validCreated = json["created"] as? String {
            created = dateFromFormattedString(validCreated)
        }
        
        if let validName = json["email"] as? String {
            email = validName
        }
    }
}

extension TimesheetUser {
    static var currentEmail: String? {
        get {
            return UserDefaults.standard.string(forKey: keychainEmailDefaultsKey)
        }
        
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: keychainEmailDefaultsKey)
            } else {
                UserDefaults.standard.set(newValue, forKey: keychainEmailDefaultsKey)
            }
        }
    }
    
    static var currentName: String? {
        get {
            return UserDefaults.standard.string(forKey: keychainNameDefaultsKey)
        }
        
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: keychainNameDefaultsKey)
            } else {
                UserDefaults.standard.set(newValue, forKey: keychainNameDefaultsKey)
            }
        }
    }
    
    static var currentPassword: String? {
        get {
            guard let email = currentEmail else {
                return nil
            }
            
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email, accessGroup: KeychainConfiguration.accessGroup)
            do {
                let keychainPassword = try passwordItem.readPassword()
                return keychainPassword
            } catch {
                return nil
            }
        }
        
        set {
            guard let password = newValue else {
                fatalError("TimesheetUserManager attempting to set nil keychainPassword.")
            }
            
            guard let email = currentEmail else {
                fatalError("TimesheetUserManager attempting to set keychainPassword without keychainEmail!")
            }
            
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email, accessGroup: KeychainConfiguration.accessGroup)
            do {
                try passwordItem.savePassword(password)
            } catch {
                fatalError("TimesheetUserManager unable to save keychainPassword")
            }
        }
    }
}
