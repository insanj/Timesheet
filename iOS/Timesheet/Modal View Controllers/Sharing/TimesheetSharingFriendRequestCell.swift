//
//  TimesheetSharingFriendRequestCell.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/12/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

class TimesheetSharingFriendRequestCell: UICollectionViewCell {
    static let reuseIdentifier: String = "TimesheetSharingFriendRequestCellIdentifier"
    
    internal let contentBackgroundView = UIView()
    internal let fromTitleLabel = UILabel()
    internal let toTitleLabel = UILabel()
    internal let fromLabel = UILabel()
    internal let toLabel = UILabel()
    let friendAddLabel = UILabel()
    
    var friendRequest: TimesheetFriendRequest? {
        didSet {
            fromLabel.text = friendRequest?.senderUser?.name
            toLabel.text = friendRequest?.receiverUser?.name
            friendAddLabel.text = friendRequest?.accepted == 1 ? "VIEW" : "ACCEPT"
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
        
        fromTitleLabel.textColor = UIColor(white: 0.2, alpha: 1.0)
        fromTitleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        fromTitleLabel.text = "FROM"
        fromTitleLabel.numberOfLines = 1
        fromTitleLabel.textAlignment = .left
        fromTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        fromTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        fromTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(fromTitleLabel)
        
        toTitleLabel.textColor = UIColor(white: 0.2, alpha: 1.0)
        toTitleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        toTitleLabel.text = "TO"
        toTitleLabel.numberOfLines = 1
        toTitleLabel.textAlignment = .left
        toTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        toTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        toTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(toTitleLabel)
        
        fromLabel.textColor = UIColor(white: 0.05, alpha: 1.0)
        fromLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        fromLabel.numberOfLines = 1
        fromLabel.textAlignment = .left
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(fromLabel)
        
        toLabel.textColor = UIColor(white: 0.05, alpha: 1.0)
        toLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        toLabel.numberOfLines = 1
        toLabel.textAlignment = .left
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(toLabel)
        
        friendAddLabel.textColor = timesheetColor(name: "Blue").backgroundColor
        friendAddLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        friendAddLabel.numberOfLines = 1
        friendAddLabel.textAlignment = .right
        friendAddLabel.text = "ACCEPT"
        friendAddLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(friendAddLabel)
        
        let view = contentBackgroundView
        fromTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        fromTitleLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        toTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        toTitleLabel.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        fromLabel.leftAnchor.constraint(equalTo: fromTitleLabel.rightAnchor, constant: 10.0).isActive = true
        fromLabel.rightAnchor.constraint(equalTo: friendAddLabel.leftAnchor, constant: -5.0).isActive = true
        fromLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        toLabel.leftAnchor.constraint(equalTo: fromTitleLabel.rightAnchor, constant: 10.0).isActive = true
        toLabel.rightAnchor.constraint(equalTo: friendAddLabel.leftAnchor, constant: -5.0).isActive = true
        toLabel.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        friendAddLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        friendAddLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

