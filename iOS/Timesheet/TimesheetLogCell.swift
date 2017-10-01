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
                dateLabel.text = log.created.debugDescription
            }
        }
    }
    
    internal let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        
        dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
