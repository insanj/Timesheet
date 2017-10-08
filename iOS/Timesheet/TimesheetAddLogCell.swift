//
//  TimesheetAddLogCell.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/7/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

class TimesheetAddLogCell: UICollectionViewCell {
    static let reuseIdentifier: String = "TimesheetAddLogCellIdentifier"
    
    internal let contentBackgroundView = UIView()
    internal let addView = UILabel()
    internal let addDetailLabel = UILabel()

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
        
        addView.textColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        addView.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        addView.numberOfLines = 1
        addView.textAlignment = .center
        addView.text = "+"
        addView.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        addView.baselineAdjustment = .alignCenters
        addView.layer.cornerRadius = 20.0
        addView.layer.masksToBounds = true
        addView.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(addView)
        
        addView.centerYAnchor.constraint(equalTo: contentBackgroundView.centerYAnchor, constant: -10.0).isActive = true
        addView.centerXAnchor.constraint(equalTo: contentBackgroundView.centerXAnchor).isActive = true
        addView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        addView.widthAnchor.constraint(equalToConstant: 40.0).isActive = true

        addDetailLabel.textColor = UIColor(white: 0.0, alpha: 0.6)
        addDetailLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        addDetailLabel.text = "Tap to add a new log"
        addDetailLabel.numberOfLines = 1
        addDetailLabel.textAlignment = .center
        addDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(addDetailLabel)
        
        addDetailLabel.topAnchor.constraint(equalTo: addView.bottomAnchor, constant: 5.0).isActive = true
        addDetailLabel.leftAnchor.constraint(equalTo: contentBackgroundView.leftAnchor, constant: 10.0).isActive = true
        addDetailLabel.rightAnchor.constraint(equalTo: contentBackgroundView.rightAnchor, constant: -10.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
