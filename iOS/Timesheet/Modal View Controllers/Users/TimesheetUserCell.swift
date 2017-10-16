//
//  TimesheetUserCell.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/15/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

class TimesheetUserCell: UICollectionViewCell {
    static let reuseIdentifier: String = "TimesheetUserCellIdentifier"
    
    internal let contentBackgroundView = UIView()
    internal let friendEmailLabel = UILabel()
    internal let friendNameLabel = UILabel()
    internal let friendDateLabel = UILabel()
    let friendAddLabel = UILabel()
    
    var user: TimesheetUser? {
        didSet {
            if let validUser = user {
                friendEmailLabel.text = validUser.email
                friendNameLabel.text = validUser.name ?? "No Name"
                friendDateLabel.text = simpleFormattedDate(validUser.created!)
            } else {
                friendEmailLabel.text = nil
                friendNameLabel.text = nil
                friendDateLabel.text = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentBackgroundView.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        contentBackgroundView.layer.masksToBounds = true
        contentBackgroundView.layer.cornerRadius = 8.0
        contentBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentBackgroundView)
        
        contentBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        contentBackgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5.0).isActive = true
        contentBackgroundView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5.0).isActive = true
        contentBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    
        friendNameLabel.textColor = UIColor(white: 0.2, alpha: 1.0)
        friendNameLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        friendNameLabel.numberOfLines = 1
        friendNameLabel.textAlignment = .left
        friendNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(friendNameLabel)
        
        friendEmailLabel.textColor = UIColor(white: 0.4, alpha: 1.0)
        friendEmailLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        friendEmailLabel.numberOfLines = 1
        friendEmailLabel.textAlignment = .left
        friendEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(friendEmailLabel)
        
        friendDateLabel.textColor = UIColor(white: 0.4, alpha: 1.0)
        friendDateLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        friendDateLabel.numberOfLines = 1
        friendDateLabel.textAlignment = .left
        friendDateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(friendDateLabel)
        
        friendAddLabel.textColor = timesheetColor(name: "Blue").backgroundColor
        friendAddLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        friendAddLabel.numberOfLines = 1
        friendAddLabel.textAlignment = .right
        friendAddLabel.text = "REQUEST"
        friendAddLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(friendAddLabel)
        
        let view = contentBackgroundView
        friendNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0).isActive = true
        friendNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        friendNameLabel.rightAnchor.constraint(equalTo: friendAddLabel.leftAnchor, constant: -5.0).isActive = true
        
        friendEmailLabel.topAnchor.constraint(equalTo: friendNameLabel.bottomAnchor, constant: 5.0).isActive = true
        friendEmailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        friendEmailLabel.rightAnchor.constraint(equalTo: friendAddLabel.leftAnchor, constant: -5.0).isActive = true
        
        friendDateLabel.topAnchor.constraint(equalTo: friendEmailLabel.bottomAnchor, constant: 5.0).isActive = true
        friendDateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        friendDateLabel.rightAnchor.constraint(equalTo: friendAddLabel.leftAnchor, constant: -5.0).isActive = true
        
        friendAddLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        friendAddLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

