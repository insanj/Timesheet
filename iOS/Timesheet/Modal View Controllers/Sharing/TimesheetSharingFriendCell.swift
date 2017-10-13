//
//  TimesheetSharingFriendCell.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/12/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

class TimesheetSharingFriendCell: UICollectionViewCell {
    static let reuseIdentifier: String = "TimesheetSharingFriendCellIdentifier"
    
    internal let contentBackgroundView = UIView()
    internal let friendNameLabel = UILabel()

    var friend: TimesheetUser? {
        didSet {
            friendNameLabel.text = friend?.name
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
        
        friendNameLabel.leftAnchor.constraint(equalTo: contentBackgroundView.leftAnchor, constant: 10.0).isActive = true
        friendNameLabel.centerYAnchor.constraint(equalTo: contentBackgroundView.centerYAnchor).isActive = true
        friendNameLabel.rightAnchor.constraint(equalTo: contentBackgroundView.rightAnchor, constant: -10.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

