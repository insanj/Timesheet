//
//  TimesheetLogCell.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/1/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

class TimesheetLogCell: UICollectionViewCell {
    static let reuseIdentifier: String = "TimesheetLogCellIdentifier"
    
    var timesheetLog: TimesheetLog? {
        didSet {
            if let log = timesheetLog {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "E"
                dayLabel.text = dateFormatter.string(from: log.timeIn!)
                
                dateFormatter.dateFormat = "d"
                dateLabel.text = dateFormatter.string(from: log.timeIn!)
                
                dateFormatter.dateFormat = "h:mm a"
                timeInLabel.text = dateFormatter.string(from: log.timeIn!)
                
                dateFormatter.dateFormat = "h:mm a"
                timeOutLabel.text = dateFormatter.string(from: log.timeOut!)
            }
        }
    }
    
    var timesheetColor: TimesheetColor? {
        didSet {
            if let color = timesheetColor {
                contentBackgroundView.backgroundColor = color.backgroundColor
                
                dayLabel.textColor = color.foregroundColor
                dateLabel.textColor = color.foregroundColor
                timeInTitleLabel.textColor = color.foregroundColor
                timeInLabel.textColor = color.foregroundColor
                timeOutTitleLabel.textColor = color.foregroundColor
                timeOutLabel.textColor = color.foregroundColor
            }
        }
    }
    
    internal let contentBackgroundView = UIView()

    internal let dayLabel = UILabel() // Wed
    internal let dateLabel = UILabel() // 12
    
    internal let timeInTitleLabel = UILabel()
    internal let timeInLabel = UILabel()

    internal let timeOutTitleLabel = UILabel()
    internal let timeOutLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentBackgroundView.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        contentBackgroundView.layer.masksToBounds = true
        contentBackgroundView.layer.cornerRadius = 8.0
        contentBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentBackgroundView)
        
        contentBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        contentBackgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5.0).isActive = true
        contentBackgroundView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5.0).isActive = true
        contentBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        // setup day & date label
        let dateBackgroundView = UIView()
        dateBackgroundView.backgroundColor = UIColor.white
        dateBackgroundView.layer.masksToBounds = true
        dateBackgroundView.layer.cornerRadius = 8.0
        dateBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(dateBackgroundView)
        
        dateBackgroundView.topAnchor.constraint(equalTo: contentBackgroundView.topAnchor, constant: 5.0).isActive = true
        dateBackgroundView.leftAnchor.constraint(equalTo: contentBackgroundView.leftAnchor, constant: 5.0).isActive = true
        dateBackgroundView.widthAnchor.constraint(equalTo: dateBackgroundView.heightAnchor).isActive = true
        dateBackgroundView.bottomAnchor.constraint(equalTo: contentBackgroundView.bottomAnchor, constant: -5.0).isActive = true

        dayLabel.textColor = UIColor.white
        dayLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        dayLabel.numberOfLines = 1
        dayLabel.textAlignment = .center
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dateBackgroundView.addSubview(dayLabel)
        
        dateLabel.textColor = UIColor.white
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        dateLabel.numberOfLines = 1
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateBackgroundView.addSubview(dateLabel)

        dateLabel.centerXAnchor.constraint(equalTo: dateBackgroundView.centerXAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: dateBackgroundView.centerYAnchor).isActive = true
        
        dayLabel.centerXAnchor.constraint(equalTo: dateBackgroundView.centerXAnchor).isActive = true
        dayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        
        // setup time in & out label
        timeInTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        timeInTitleLabel.textColor = UIColor.white
        timeInTitleLabel.numberOfLines = 1
        timeInTitleLabel.textAlignment = .left
        timeInTitleLabel.text = "IN"
        timeInTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        timeInTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        timeInTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(timeInTitleLabel)
        
        timeInLabel.textColor = UIColor.white
        timeInLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        timeInLabel.textColor = UIColor.white
        timeInLabel.numberOfLines = 1
        timeInLabel.textAlignment = .right
        timeInLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(timeInLabel)
        
        timeOutTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        timeOutTitleLabel.textColor = UIColor.white
        timeOutTitleLabel.numberOfLines = 1
        timeOutTitleLabel.textAlignment = .left
        timeOutTitleLabel.text = "OUT"
        timeOutTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        timeOutTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        timeOutTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(timeOutTitleLabel)
        
        timeOutLabel.textColor = UIColor.white
        timeOutLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        timeOutLabel.textColor = UIColor.white
        timeOutLabel.numberOfLines = 1
        timeOutLabel.textAlignment = .right
        timeOutLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(timeOutLabel)
        
        timeInTitleLabel.leftAnchor.constraint(equalTo: dateBackgroundView.rightAnchor, constant: 10.0).isActive = true
        timeInTitleLabel.bottomAnchor.constraint(equalTo: dateBackgroundView.centerYAnchor).isActive = true

        timeInLabel.leftAnchor.constraint(equalTo: timeInTitleLabel.rightAnchor, constant: 10.0).isActive = true
        timeInLabel.centerYAnchor.constraint(equalTo: timeInTitleLabel.centerYAnchor).isActive = true
        timeInLabel.rightAnchor.constraint(equalTo: contentBackgroundView.rightAnchor, constant: -10.0).isActive = true

        timeOutTitleLabel.leftAnchor.constraint(equalTo: dateBackgroundView.rightAnchor, constant: 10.0).isActive = true
        timeOutTitleLabel.topAnchor.constraint(equalTo: dateBackgroundView.centerYAnchor).isActive = true

        timeOutLabel.leftAnchor.constraint(equalTo: timeOutTitleLabel.rightAnchor, constant: 10.0).isActive = true
        timeOutLabel.centerYAnchor.constraint(equalTo: timeOutTitleLabel.centerYAnchor).isActive = true
        timeOutLabel.rightAnchor.constraint(equalTo: contentBackgroundView.rightAnchor, constant: -10.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
