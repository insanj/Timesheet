//
//  TimesheetPulldownView.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/9/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

class TimesheetPulldownView: UIView {
    let changeNameButton: TimesheetButton
    let signOutButton: TimesheetButton
    
    init() {
        signOutButton = TimesheetButton(timesheetColor(name: "Aqua"))
        changeNameButton = TimesheetButton(timesheetColor(name: "Orange"))

        super.init(frame: CGRect.zero)
        
        // setup sign out button
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(signOutButton)
        
        signOutButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        signOutButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        signOutButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true

        // setup change name button
        changeNameButton.setTitle("Change Name", for: .normal)
        changeNameButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(changeNameButton)
        
        changeNameButton.bottomAnchor.constraint(equalTo: signOutButton.topAnchor, constant: -5.0).isActive = true
        changeNameButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        changeNameButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
        changeNameButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
