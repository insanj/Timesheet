//
//  Convenience.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/1/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import Foundation

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
