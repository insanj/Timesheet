//
//  Convenience.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/1/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

func debugPrint(_ message: String) {
    print("[TIMESHEET] <DEBUG> (\(Date().debugDescription): \(message)")
}

func dateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter
}

func formattedDate(_ date: Date) -> String {
    return dateFormatter().string(from: date)
}

func dateFromFormattedString(_ string: String) -> Date? {
    return dateFormatter().date(from: string)
}

enum TimesheetErrorType: Int {
    case unableToConnect = 1, unexpectedResponse, unableToParse, invalidURL
}

func timesheetError(_ type: TimesheetErrorType) -> Error {
    debugPrint("\(#function), type = \(type.rawValue)")
    
    switch type {
    case .unableToConnect:
        return NSError(domain: "com.insanj.timesheet", code: type.rawValue, userInfo: [NSLocalizedDescriptionKey : "Unable to connect to the internet."])
    case .unexpectedResponse:
        return NSError(domain: "com.insanj.timesheet", code: type.rawValue, userInfo: [NSLocalizedDescriptionKey : "Unusual response while trying to connect to internet."])
    case .unableToParse:
        return NSError(domain: "com.insanj.timesheet", code: type.rawValue, userInfo: [NSLocalizedDescriptionKey : "Unusual response while downloading information from the internet."])
    case .invalidURL:
        return NSError(domain: "com.insanj.timesheet", code: type.rawValue, userInfo: [NSLocalizedDescriptionKey : "Trouble finding a way to connect to and download information from the internet."])
    }
}

func showError(_ error: Error, from: UIViewController) {
    let errorAlert = UIAlertController(title: "Uh-oh!", message: error.localizedDescription, preferredStyle: .alert)
    errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    from.present(errorAlert, animated: true)/* {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
            from.dismiss(animated: true, completion: nil)
        })
    }*/
}

let timesheetDateComponents:Set<Calendar.Component> = [.calendar, .timeZone, .year, .month, .day, .weekday, .hour, .minute]
