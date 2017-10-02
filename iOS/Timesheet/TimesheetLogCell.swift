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
            }
        }
    }
    
    internal let dayLabel = UILabel() // Wed
    internal let dateLabel = UILabel() // 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // setup day & date label
        dayLabel.textColor = UIColor.white
        dayLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        dayLabel.numberOfLines = 1
        dayLabel.textAlignment = .center
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dayLabel)
        
        dateLabel.textColor = UIColor.white
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        dateLabel.numberOfLines = 1
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)

        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -7.5).isActive = true
        
        dayLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        dayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        
        // setup separator view
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
