//
//  TimesheetPulldownView.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/9/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit
import BulletinBoard

class TimesheetPulldownView: UIView {
    let signOutButton = UIButton()
    
    init() {
        super.init(frame: CGRect.zero)
        
        let color = timesheetColor(name: "Aqua")
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        signOutButton.backgroundColor = color.backgroundColor
        signOutButton.setTitleColor(color.foregroundColor, for: .normal)
        signOutButton.layer.masksToBounds = true
        signOutButton.layer.cornerRadius = 8.0
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(signOutButton)
        
        signOutButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        signOutButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        signOutButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
