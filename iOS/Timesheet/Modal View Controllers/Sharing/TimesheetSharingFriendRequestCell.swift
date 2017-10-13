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
    
    var friendRequest: TimesheetFriendRequest? {
        didSet {
            fromLabel.text = friendRequest?.senderUser?.name
            toLabel.text = friendRequest?.receiverUser?.name
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
        fromTitleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        fromTitleLabel.text = "FROM"
        fromTitleLabel.numberOfLines = 1
        fromTitleLabel.textAlignment = .left
        fromTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(fromTitleLabel)
        
        toTitleLabel.textColor = UIColor(white: 0.2, alpha: 1.0)
        toTitleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        toTitleLabel.text = "TO"
        toTitleLabel.numberOfLines = 1
        toTitleLabel.textAlignment = .right
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
        toLabel.textAlignment = .right
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(toLabel)
        
        let view = contentBackgroundView
        fromTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        fromTitleLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        toTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
        toTitleLabel.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        fromLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5.0).isActive = true
        fromLabel.leftAnchor.constraint(equalTo: fromTitleLabel.rightAnchor, constant: 5.0).isActive = true
        fromLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        toLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        toLabel.rightAnchor.constraint(equalTo: toTitleLabel.rightAnchor, constant: -10.0).isActive = true
        toLabel.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

