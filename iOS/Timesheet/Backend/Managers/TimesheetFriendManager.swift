//
//  TimesheetFriendManager.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/12/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

class TimesheetFriendManager: NSObject {
    func buildFriendRequestsForUserURLRequest() -> URLRequest? {
        guard let email = TimesheetUser.currentEmail, let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetUserManager buildEditUserNameURLRequest not authenticated")
            return nil
        }
        
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "friendRequestsForUser"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password)]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }
    
    func buildCreateFriendRequestURLRequest(friend: TimesheetUser) -> URLRequest? {
        guard let email = TimesheetUser.currentEmail, let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetUserManager buildEditUserNameURLRequest not authenticated")
            return nil
        }
        
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "createFriendRequest"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password),
                           URLQueryItem(name: "friend_user_id", value: String(friend.userId!))]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }
    
    func buildAcceptFriendRequestURLRequest(friend: TimesheetUser) -> URLRequest? {
        guard let email = TimesheetUser.currentEmail, let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetUserManager buildEditUserNameURLRequest not authenticated")
            return nil
        }
        
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "acceptFriendRequest"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password),
                           URLQueryItem(name: "friend_user_id", value: String(friend.userId!))]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }
    
    func buildDeleteFriendRequestURLRequest(friend: TimesheetUser) -> URLRequest? {
        guard let email = TimesheetUser.currentEmail, let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetUserManager buildEditUserNameURLRequest not authenticated")
            return nil
        }
        
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "deleteFriendRequest"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password),
                           URLQueryItem(name: "friend_user_id", value: String(friend.userId!))]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }
    
    func buildGetLogsFromFriendURLRequest(friend: TimesheetUser) -> URLRequest? {
        guard let email = TimesheetUser.currentEmail, let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetUserManager buildEditUserNameURLRequest not authenticated")
            return nil
        }
        
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "getLogsFromFriend"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password),
                           URLQueryItem(name: "friend_user_id", value: String(friend.userId!))]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }
    
    func buildGetAvailableUsersURLRequest() -> URLRequest? {
        guard let email = TimesheetUser.currentEmail, let password = TimesheetUser.currentPassword else {
            debugPrint("TimesheetUserManager buildGetAvailableUsersURLRequest not authenticated")
            return nil
        }
        
        var request = URLRequest(url: timesheetBaseURL)
        request.httpMethod = "POST"
        
        var url = URLComponents(string: timesheetBaseURLString)
        url?.queryItems = [URLQueryItem(name: "v", value: "0.1"),
                           URLQueryItem(name: "req", value: "getAvailableUsers"),
                           URLQueryItem(name: "email", value: email),
                           URLQueryItem(name: "password", value: password)]
        request.httpBody = url?.query?.data(using: .utf8)
        return request
    }
    
    typealias FriendRequestCompletionBlock = (([TimesheetFriendRequest]?, Error?) -> Void)
    func remoteFriendRequestTask(with urlRequest: URLRequest, _ completion: @escaping FriendRequestCompletionBlock) -> URLSessionDataTask {
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
                
                let parsed = array.flatMap {
                    TimesheetFriendRequest(json: $0)
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
    
    func friendRequestsForUser(_ completion: @escaping FriendRequestCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildFriendRequestsForUserURLRequest() else {
            debugPrint("friendRequestsForUser() unable to build URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteFriendRequestTask(with: urlRequest, completion)
        task.resume()
        return task
    }
    
    func ceateFriendRequest(friend: TimesheetUser, _ completion: @escaping FriendRequestCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildCreateFriendRequestURLRequest(friend: friend) else {
            debugPrint("ceateFriendRequest() unable to build URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteFriendRequestTask(with: urlRequest, completion)
        task.resume()
        return task
    }
    
    func acceptFriendRequest(friend: TimesheetUser, _ completion: @escaping FriendRequestCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildAcceptFriendRequestURLRequest(friend: friend) else {
            debugPrint("acceptFriendRequest() unable to build URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteFriendRequestTask(with: urlRequest, completion)
        task.resume()
        return task
    }
    
    func deleteFriendRequest(friend: TimesheetUser, _ completion: @escaping FriendRequestCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildDeleteFriendRequestURLRequest(friend: friend) else {
            debugPrint("deleteFriendRequest() unable to build URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = remoteFriendRequestTask(with: urlRequest, completion)
        task.resume()
        return task
    }
    
    func getLogsFromFriend(friend: TimesheetUser, _ completion: @escaping LogsCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildGetLogsFromFriendURLRequest(friend: friend) else {
            debugPrint("getLogsFromFriend() unable to build URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
        let task = TimesheetDataManager().remoteTask(with: urlRequest, completion)
        task.resume()
        return task
    }
    
    typealias UsersCompletionBlock = (([TimesheetUser]?, Error?) -> Void)
    func getAvailableUsers(_ completion: @escaping UsersCompletionBlock) -> URLSessionDataTask? {
        guard let urlRequest = buildGetAvailableUsersURLRequest() else {
            debugPrint("getAvailableUsers() unable to build URL; cannot load from remote!")
            completion(nil, timesheetError(.invalidURL))
            return nil
        }
        
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
                
                var users = [TimesheetUser]()
                for user in array {
                    users.append(TimesheetUser(json: user))
                }
                
                completion(users, nil)
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
}
