//
//  TimesheetStyle.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/7/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

class TimesheetColor: NSObject {
    let backgroundColor: UIColor
    let foregroundColor: UIColor
    let name: String
    
    init(_ name: String, _ backgroundColor: UIColor, _ foregroundColor: UIColor) {
        self.name = name
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        
        super.init()
    }
}

let timesheetColors: [TimesheetColor] = [
    TimesheetColor("Navy", UIColor(red: 0.00392, green: 0.125, blue: 0.243, alpha: 1), UIColor(red: 0.506, green: 0.753, blue: 0.992, alpha: 1)),
    TimesheetColor("Blue", UIColor(red: 0.0706, green: 0.467, blue: 0.839, alpha: 1), UIColor(red: 0.706, green: 0.863, blue: 0.996, alpha: 1)),
    TimesheetColor("Aqua", UIColor(red: 0.514, green: 0.859, blue: 0.992, alpha: 1), UIColor(red: 0.0235, green: 0.29, blue: 0.396, alpha: 1)),
    TimesheetColor("Teal", UIColor(red: 0.263, green: 0.796, blue: 0.796, alpha: 1), UIColor(red: 0, green: 0, blue: 0, alpha: 1)),
    TimesheetColor("Olive", UIColor(red: 0.259, green: 0.596, blue: 0.443, alpha: 1), UIColor(red: 0.0863, green: 0.212, blue: 0.161, alpha: 1)),
    TimesheetColor("Green", UIColor(red: 0.224, green: 0.792, blue: 0.286, alpha: 1), UIColor(red: 0.0627, green: 0.243, blue: 0.0824, alpha: 1)),
    TimesheetColor("Lime", UIColor(red: 0.165, green: 0.992, blue: 0.467, alpha: 1), UIColor(red: 0.0392, green: 0.396, blue: 0.184, alpha: 1)),
    TimesheetColor("Yellow", UIColor(red: 0.996, green: 0.855, blue: 0.196, alpha: 1), UIColor(red: 0.4, green: 0.345, blue: 0.051, alpha: 1)),
    TimesheetColor("Orange", UIColor(red: 0.992, green: 0.522, blue: 0.184, alpha: 1), UIColor(red: 0.396, green: 0.184, blue: 0.0275, alpha: 1)),
    TimesheetColor("Red", UIColor(red: 0.992, green: 0.267, blue: 0.243, alpha: 1), UIColor(red: 0.49, green: 0.0314, blue: 0.0314, alpha: 1)),
    TimesheetColor("Maroon", UIColor(red: 0.514, green: 0.0941, blue: 0.294, alpha: 1), UIColor(red: 0.918, green: 0.486, blue: 0.69, alpha: 1)),
    TimesheetColor("Fuchsia", UIColor(red: 0.933, green: 0.145, blue: 0.737, alpha: 1), UIColor(red: 0.392, green: 0.0471, blue: 0.306, alpha: 1)),
    TimesheetColor("Purple", UIColor(red: 0.686, green: 0.133, blue: 0.776, alpha: 1), UIColor(red: 0.933, green: 0.671, blue: 0.973, alpha: 1)),
    TimesheetColor("Black", UIColor(red: 0.0667, green: 0.0667, blue: 0.0667, alpha: 1), UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1))
]

func timesheetRandomColor() -> TimesheetColor {
    let random = Int(arc4random_uniform(UInt32(timesheetColors.count)))
    return timesheetColors[random]
}

