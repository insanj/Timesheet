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
    
    func buildEditUserNameURLRequest(name: String) -> URLRequest? {
        guard let email = TimesheetUser.currentEmail, let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetUserManager buildEditUserNameURLRequest not authenticated")
            return nil
        }
        
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "editUserName"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password),
                           URLQueryItem(name: "user_name", value: name)]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }

    func buildEditEmailURLRequest(email newEmail: String) -> URLRequest? {
        guard let email = TimesheetUser.currentEmail, let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetUserManager buildEditEmailURLRequest not authenticated")
            return nil
        }
        
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "editEmail"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password),
                           URLQueryItem(name: "new_email", value: newEmail)]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }

    func buildEditPasswordURLRequest(password newPassword: String) -> URLRequest? {
        guard let email = TimesheetUser.currentEmail, let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetUserManager buildEditPasswordURLRequest not authenticated")
            return nil
        }
        
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "editPassword"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password),
                           URLQueryItem(name: "new_password", value: newPassword)]
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
                    let dataString = String(data: validData, encoding: .utf8)
                    if dataString != nil {
                        debugPrint("TimesheetUserManager something that isn't a user returned (dataString =\(dataString!)); \(array.debugDescription)")
                        completion(nil, NSError(domain: "com.insanj.timesheet", code: -1, userInfo: [NSLocalizedDescriptionKey: dataString!]))
                    } else {
                        completion(nil, timesheetError(.unableToSave))
                    }
                }
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
    
    func editUserNameInRemoteDatabase(name: String, _ completion: @escaping UserCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildEditUserNameURLRequest(name: name) else {
            debugPrint("editUserNameInRemoteDatabase() unable to build URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteUserTask(with: urlRequest, completion)
        task.resume()
        return task
    }

    func editEmailInRemoteDatabase(email: String, _ completion: @escaping UserCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildEditEmailURLRequest(email: email) else {
            debugPrint("editEmailInRemoteDatabase() unable to build URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteUserTask(with: urlRequest, completion)
        task.resume()
        return task
    }

    func editPasswordInRemoteDatabase(password: String, _ completion: @escaping UserCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildEditPasswordURLRequest(password: password) else {
            debugPrint("buildEditPasswordURLRequest() unable to build URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteUserTask(with: urlRequest, completion)
        task.resume()
        return task
    }
}
