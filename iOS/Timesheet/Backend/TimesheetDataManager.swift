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
    let timesheetUserId:Int = 1 // in the future, this should be dynamic...
    
    /* MARK: - local
    func logsFromLocalDatabase() -> [TimesheetLog]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            debugPrint("logsFromDatabase() Unable to access application delegate")
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TimesheetLog")
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            debugPrint("logsFromDatabase() Could not fetch \(error), \(error.userInfo)")
            return nil
        }
    }*/
    
    // MARK: - remote    
    func buildAddLogURL(timeIn: Date, timeOut: Date, _ notes: String = "") -> URL? {
        let timeInString = formattedDate(timeIn)
        let timeOutString = formattedDate(timeOut)
        
        var url = URLComponents(string: "http://insanj.com/timesheet/api.php")
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "add"),
                           URLQueryItem(name: "user_id", value: String(timesheetUserId)),
                           URLQueryItem(name: "time_in", value: timeInString),
                           URLQueryItem(name: "time_out", value: timeOutString),
                           URLQueryItem(name: "notes", value: notes)]
        return url?.url
    }
    
    func buildLogsURL() -> URL? {
        var url = URLComponents(string: "http://insanj.com/timesheet/api.php")
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "history"),
                           URLQueryItem(name: "user_id", value: String(timesheetUserId))]
        return url?.url
    }
    
    func buildEditLogURL(log: TimesheetLog) -> URL? {
        let timeInString = formattedDate(log.timeIn!)
        let timeOutString = formattedDate(log.timeOut!)
        let notes = log.notes ?? ""
        let logIdString = String(log.logId!)
        
        var url = URLComponents(string: "http://insanj.com/timesheet/api.php")
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "edit"),
                           URLQueryItem(name: "user_id", value: String(timesheetUserId)),
                           URLQueryItem(name: "log_id", value: logIdString),
                           URLQueryItem(name: "time_in", value: timeInString),
                           URLQueryItem(name: "time_out", value: timeOutString),
                           URLQueryItem(name: "notes", value: notes)]
        return url?.url
    }
    
    func buildDeleteLogURL(log: TimesheetLog) -> URL? {
        let logIdString = String(log.logId!)
        
        var url = URLComponents(string: "http://insanj.com/timesheet/api.php")
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "delete"),
                           URLQueryItem(name: "user_id", value: String(timesheetUserId)),
                           URLQueryItem(name: "log_id", value: logIdString)]
        return url?.url
    }
    
    typealias LogsCompletionBlock = (([TimesheetLog]?, Error?) -> Void)
    func remoteTask(with url: URL, _ completion: @escaping LogsCompletionBlock) -> URLSessionDataTask {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            debugPrint("remoteTask() dataTask, data=\(data.debugDescription), response=\(response.debugDescription), error=\(error.debugDescription)")
            
            if let validError = error {
                completion(nil, validError)
                return
            }
            
            guard let validData = data else {
                completion(nil, timesheetError(.unableToConnect))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: .allowFragments)
                guard let array = json as? [[AnyHashable: Any]] else {
                    completion(nil, timesheetError(.unexpectedResponse))
                    return
                }
                
                let parsed = array.flatMap {
                    TimesheetLog(json: $0)
                }
                
                completion(parsed, nil)
            } catch {
                completion(nil, timesheetError(.unableToParse))
                return
            }
        }
        
        return task
    }
    
    func logsFromRemoteDatabase(_ completion: @escaping LogsCompletionBlock) -> URLSessionDataTask? {
        guard let url = buildLogsURL() else {
            debugPrint("logsFromRemoteDatabase() unable to build logs URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteTask(with: url, completion)
        task.resume()
        return task
    }
    
    func addLogToRemoteDatabase(timeIn: Date, timeOut: Date, _ completion: @escaping LogsCompletionBlock) -> URLSessionDataTask? {
        guard let url = buildAddLogURL(timeIn: timeIn, timeOut: timeOut) else {
            debugPrint("addLogsToRemoteDatabase() unable to build logs URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteTask(with: url, completion)
        task.resume()
        return task
    }
    
    func editLogInRemoteDatabase(log: TimesheetLog, _ completion: @escaping LogsCompletionBlock) -> URLSessionDataTask? {
        guard let url = buildEditLogURL(log: log) else {
            debugPrint("editLogInRemoteDatabase() unable to build logs URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteTask(with: url, completion)
        task.resume()
        return task
    }
    
    func deleteLogInRemoteDatabase(log: TimesheetLog, _ completion: @escaping LogsCompletionBlock) -> URLSessionDataTask? {
        guard let url = buildDeleteLogURL(log: log) else {
            debugPrint("deleteLogInRemoteDatabase() unable to build logs URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteTask(with: url, completion)
        task.resume()
        return task
    }
}
