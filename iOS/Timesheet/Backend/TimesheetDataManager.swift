//
//  TimesheetDataManager.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/1/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit
import CoreData

class TimesheetDataManager: NSObject {
    // MARK: - local
    func logsFromLocalDatabase() -> [TimesheetLog]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            debugPrint("logsFromDatabase() Unable to access application delegate")
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TimesheetLog")
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            return objects as? [TimesheetLog]
        } catch let error as NSError {
            debugPrint("logsFromDatabase() Could not fetch \(error), \(error.userInfo)")
            return nil
        }
    }
    
    // MARK: - remote
    func logsFromRemoteDatabase() -> [TimesheetLog]? {
        
    }
}
