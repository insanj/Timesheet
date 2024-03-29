//
//  TimesheetPulldownView.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/9/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

class TimesheetPulldownView: UIView {
    let iTunesArtworkView = UIImageView(image: UIImage(named: "iTunesArtwork"))
    let changePasswordButton: TimesheetButton
    let changeNameButton: TimesheetButton
    let changeEmailButton: TimesheetButton
    let deactivateButton: TimesheetButton
    let signOutButton: TimesheetButton

    init() {
        signOutButton = TimesheetButton(timesheetColor(name: "Aqua"))
        changeNameButton = TimesheetButton(timesheetColor(name: "Orange"))
        changePasswordButton = TimesheetButton(timesheetColor(name: "Maroon"))
        changeEmailButton = TimesheetButton(timesheetColor(name: "Olive"))
        deactivateButton = TimesheetButton(timesheetColor(name: "Navy"))

        super.init(frame: CGRect.zero)
        
        // setup delete account button
        deactivateButton.setTitle("       Deactivate       ", for: .normal)
        deactivateButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        deactivateButton.setContentHuggingPriority(.required, for: .horizontal)
        deactivateButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(deactivateButton)
        
        deactivateButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        deactivateButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
        deactivateButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        // setup sign out button
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(signOutButton)
        
        signOutButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        signOutButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        signOutButton.rightAnchor.constraint(equalTo: deactivateButton.leftAnchor, constant: -10.0).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        // setup change name button
        changeNameButton.setTitle("       Name       ", for: .normal) // TODO: insets
        changeNameButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        changeNameButton.setContentHuggingPriority(.required, for: .horizontal)
        changeNameButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(changeNameButton)
        
        changeNameButton.bottomAnchor.constraint(equalTo: signOutButton.topAnchor, constant: -5.0).isActive = true
        changeNameButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
        changeNameButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        // setup change email button
        changeEmailButton.setTitle("Change Email", for: .normal)
        changeEmailButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(changeEmailButton)
        
        changeEmailButton.bottomAnchor.constraint(equalTo: signOutButton.topAnchor, constant: -5.0).isActive = true
        changeEmailButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        changeEmailButton.rightAnchor.constraint(equalTo: changeNameButton.leftAnchor, constant: -10.0).isActive = true
        changeEmailButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true

        // setup change password button
        changePasswordButton.setTitle("Change Password", for: .normal)
        changePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(changePasswordButton)
        
        changePasswordButton.bottomAnchor.constraint(equalTo: changeNameButton.topAnchor, constant: -5.0).isActive = true
        changePasswordButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        changePasswordButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
        changePasswordButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        // setup itunesArtworkView
        iTunesArtworkView.layer.cornerRadius = 8.0
        iTunesArtworkView.layer.masksToBounds = true
        iTunesArtworkView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iTunesArtworkView)
        
        iTunesArtworkView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iTunesArtworkView.bottomAnchor.constraint(equalTo: changePasswordButton.topAnchor, constant: -10.0).isActive = true
        iTunesArtworkView.widthAnchor.constraint(equalTo: iTunesArtworkView.heightAnchor).isActive = true
        iTunesArtworkView.topAnchor.constraint(equalTo: topAnchor, constant: 30.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
