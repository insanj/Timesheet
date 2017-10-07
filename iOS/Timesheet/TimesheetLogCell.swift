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
    
    internal let dayLabel = UILabel() // Wed
    internal let dateLabel = UILabel() // 12
    
    internal let timeInTitleLabel = UILabel()
    internal let timeInLabel = UILabel()

    internal let timeOutTitleLabel = UILabel()
    internal let timeOutLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 8.0
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundView)
        
        backgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5.0).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5.0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0).isActive = true

        // setup day & date label
        let dateBackgroundView = UIView()
        dateBackgroundView.backgroundColor = UIColor.black
        dateBackgroundView.layer.masksToBounds = true
        dateBackgroundView.layer.cornerRadius = 8.0
        dateBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(dateBackgroundView)
        
        dateBackgroundView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 5.0).isActive = true
        dateBackgroundView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 5.0).isActive = true
        dateBackgroundView.widthAnchor.constraint(equalTo: dateBackgroundView.heightAnchor).isActive = true
        dateBackgroundView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -5.0).isActive = true

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
        backgroundView.addSubview(timeInTitleLabel)
        
        timeInLabel.textColor = UIColor.white
        timeInLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        timeInLabel.textColor = UIColor.white
        timeInLabel.numberOfLines = 1
        timeInLabel.textAlignment = .right
        timeInLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(timeInLabel)
        
        timeOutTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        timeOutTitleLabel.textColor = UIColor.white
        timeOutTitleLabel.numberOfLines = 1
        timeOutTitleLabel.textAlignment = .left
        timeOutTitleLabel.text = "OUT"
        timeOutTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        timeOutTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        timeOutTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(timeOutTitleLabel)
        
        timeOutLabel.textColor = UIColor.white
        timeOutLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        timeOutLabel.textColor = UIColor.white
        timeOutLabel.numberOfLines = 1
        timeOutLabel.textAlignment = .right
        timeOutLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(timeOutLabel)
        
        timeInTitleLabel.leftAnchor.constraint(equalTo: dateBackgroundView.rightAnchor, constant: 10.0).isActive = true
        timeInTitleLabel.bottomAnchor.constraint(equalTo: dateBackgroundView.centerYAnchor).isActive = true

        timeInLabel.leftAnchor.constraint(equalTo: timeInTitleLabel.rightAnchor, constant: 10.0).isActive = true
        timeInLabel.centerYAnchor.constraint(equalTo: timeInTitleLabel.centerYAnchor).isActive = true
        timeInLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -10.0).isActive = true

        timeOutTitleLabel.leftAnchor.constraint(equalTo: dateBackgroundView.rightAnchor, constant: 10.0).isActive = true
        timeOutTitleLabel.topAnchor.constraint(equalTo: dateBackgroundView.centerYAnchor).isActive = true

        timeOutLabel.leftAnchor.constraint(equalTo: timeOutTitleLabel.rightAnchor, constant: 10.0).isActive = true
        timeOutLabel.centerYAnchor.constraint(equalTo: timeOutTitleLabel.centerYAnchor).isActive = true
        timeOutLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -10.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
