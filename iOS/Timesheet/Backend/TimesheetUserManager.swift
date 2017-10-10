//
//  TimesheetUserManager.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/9/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

class TimesheetUserManager: NSObject {
    func keychainAuthenticate(_ sender: UIViewController, _ completion: @escaping (TimesheetUser?) -> Void) {
        guard let email = TimesheetUser.currentEmail else {
            debugPrint("TimesheetUserManager keychainAuthenticate unable to find email")
            completion(nil)
            return
        }
        
        guard let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetUserManager keychainAuthenticate unable to find password")
            completion(nil)
            return
        }
        
        _ = loginInRemoteDatabase(email: email, password: password) { (user, error) in
            if let validError = error {
                showError(validError, from: sender)
                completion(nil)
            } else if user != nil {
                completion(user)
            } else {
                debugPrint("TimesheetUserManager loginInRemoteDatabase empty response")
                completion(nil)
            }
        }
    }
    
    func buildLoginURLRequest(email: String, password: String) -> URLRequest? {
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "login"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password)]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }
    
    func buildCreateAccountURLRequest(email: String, password: String) -> URLRequest? {
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "register"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password)]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }
    
    func buildEditAccountURLRequest(newName: String?, newEmail: String?, newPassword: String?) -> URLRequest? {
        guard let email = TimesheetUser.currentEmail, let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetUserManager buildEditAccountURLRequest not authenticated")
            return nil
        }
        
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "editUser"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password),
                           URLQueryItem(name: "user_name", value: newName),
                           URLQueryItem(name: "user_new_email", value: newEmail),
                           URLQueryItem(name: "user_new_password", value: newPassword)]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }
    
    typealias UserCompletionBlock = ((TimesheetUser?, Error?) -> Void)
    func remoteUserTask(with urlRequest: URLRequest, _ completion: @escaping UserCompletionBlock) -> URLSessionDataTask {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            // debugPrint("remoteUserTask() dataTask, data=\(data.debugDescription), response=\(response.debugDescription), error=\(error.debugDescription)")
            
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
                
                if let userArray = array.first {
                    let user = TimesheetUser(json: userArray)
                    completion(user, nil)
                } else {
                    completion(nil, timesheetError(.unableToSave))
                }
            } catch {
                if let string = String(data: validData, encoding: .utf8) {
                    completion(nil, NSError(domain: "com.insanj.timsheet", code: -1, userInfo: [NSLocalizedDescriptionKey: string]))
                } else {
                    completion(nil, timesheetError(.unableToParse))
                }
                return
            }
        }
        
        return task
    }
    
    func loginInRemoteDatabase(email: String, password: String, _ completion: @escaping UserCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildLoginURLRequest(email: email, password: password) else {
            debugPrint("loginInRemoteDatabase() unable to build URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteUserTask(with: urlRequest, completion)
        task.resume()
        return task
    }
    
    func createAccountInRemoteDatabase(email: String, password: String, _ completion: @escaping UserCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildCreateAccountURLRequest(email: email, password: password) else {
            debugPrint("createAccountInRemoteDatabase() unable to build URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteUserTask(with: urlRequest, completion)
        task.resume()
        return task
    }
    
    func editAccountInRemoteDatabase(newName: String, newEmail: String?, newPassword: String?, _ completion: @escaping UserCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildEditAccountURLRequest(newName: newName, newEmail: newEmail, newPassword: newPassword) else {
            debugPrint("createAccountInRemoteDatabase() unable to build URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteUserTask(with: urlRequest, completion)
        task.resume()
        return task
    }
}
