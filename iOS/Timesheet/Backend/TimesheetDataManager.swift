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
    func buildAddLogURLRequest(timeIn: Date, timeOut: Date, _ notes: String = "") -> URLRequest? {
        guard let email = TimesheetUser.currentEmail, let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetDataManager buildAddLogURLRequest not authenticated")
            return nil
        }
        
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        let timeInString = formattedDate(timeIn)
        let timeOutString = formattedDate(timeOut)
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "add"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password),
                           URLQueryItem(name: "time_in", value: timeInString),
                           URLQueryItem(name: "time_out", value: timeOutString),
                           URLQueryItem(name: "notes", value: notes)]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }
    
    func buildLogsURLRequest() -> URLRequest? {
        guard let email = TimesheetUser.currentEmail, let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetDataManager buildAddLogURLRequest not authenticated")
            return nil
        }
        
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "history"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password)]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }
    
    func buildEditLogURLRequest(log: TimesheetLog) -> URLRequest? {
        guard let email = TimesheetUser.currentEmail, let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetDataManager buildAddLogURLRequest not authenticated")
            return nil
        }
        
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        let timeInString = formattedDate(log.timeIn!)
        let timeOutString = formattedDate(log.timeOut!)
        let notes = log.notes ?? ""
        let logIdString = String(log.logId!)
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "edit"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password),
                           URLQueryItem(name: "log_id", value: logIdString),
                           URLQueryItem(name: "time_in", value: timeInString),
                           URLQueryItem(name: "time_out", value: timeOutString),
                           URLQueryItem(name: "notes", value: notes)]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }
    
    func buildDeleteLogURLRequest(log: TimesheetLog) -> URLRequest? {
        guard let email = TimesheetUser.currentEmail, let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetDataManager buildAddLogURLRequest not authenticated")
            return nil
        }
        
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        let logIdString = String(log.logId!)
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "delete"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password),
                           URLQueryItem(name: "log_id", value: logIdString)]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }
    
    typealias LogsCompletionBlock = (([TimesheetLog]?, Error?) -> Void)
    func remoteTask(with urlRequest: URLRequest, _ completion: @escaping LogsCompletionBlock) -> URLSessionDataTask {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            // debugPrint("remoteTask() dataTask, data=\(data.debugDescription), response=\(response.debugDescription), error=\(error.debugDescription)")
            
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
                if let string = String(data: validData, encoding: .utf8) {
                    completion(nil, NSError(domain: "com.insanj.timesheet", code: -1, userInfo: [NSLocalizedDescriptionKey: string]))
                } else {
                    completion(nil, timesheetError(.unableToParse))
                }
                return
            }
        }
        
        return task
    }
    
    func logsFromRemoteDatabase(_ completion: @escaping LogsCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildLogsURLRequest() else {
            debugPrint("logsFromRemoteDatabase() unable to build logs URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteTask(with: urlRequest, completion)
        task.resume()
        return task
    }
    
    func addLogToRemoteDatabase(timeIn: Date, timeOut: Date, _ completion: @escaping LogsCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildAddLogURLRequest(timeIn: timeIn, timeOut: timeOut) else {
            debugPrint("addLogsToRemoteDatabase() unable to build logs URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteTask(with: urlRequest, completion)
        task.resume()
        return task
    }
    
    func editLogInRemoteDatabase(log: TimesheetLog, _ completion: @escaping LogsCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildEditLogURLRequest(log: log) else {
            debugPrint("editLogInRemoteDatabase() unable to build logs URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteTask(with: urlRequest, completion)
        task.resume()
        return task
    }
    
    func deleteLogInRemoteDatabase(log: TimesheetLog, _ completion: @escaping LogsCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildDeleteLogURLRequest(log: log) else {
            debugPrint("deleteLogInRemoteDatabase() unable to build logs URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteTask(with: urlRequest, completion)
        task.resume()
        return task
    }
}
