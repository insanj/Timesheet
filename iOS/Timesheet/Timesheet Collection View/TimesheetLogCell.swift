//
//  TimesheetLogCell.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/1/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit
import Hero

class TimesheetLogCell: UICollectionViewCell {
    static let reuseIdentifier: String = "TimesheetLogCellIdentifier"
    static let height: CGFloat = 100.0
    
    let timesheetLogCellView: TimesheetLogCellView?
    
    var timesheetLog: TimesheetLog? {
        set {
            timesheetLogCellView?.timesheetLog = newValue
        }
        
        get {
            return timesheetLogCellView?.timesheetLog
        }
    }
    
    var timesheetColor: TimesheetColor? {
        set {
            timesheetLogCellView?.timesheetColor = newValue
        }
        
        get {
            return timesheetLogCellView?.timesheetColor
        }
    }
    
    override init(frame: CGRect) {
        timesheetLogCellView = TimesheetLogCellView(frame: frame)

        super.init(frame: frame)
        
        timesheetLogCellView!.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timesheetLogCellView!)
        
        timesheetLogCellView?.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        timesheetLogCellView?.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        timesheetLogCellView?.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        timesheetLogCellView?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class TimesheetLogCellView: UIView {
    var timesheetLog: TimesheetLog? {
        didSet {
            if let log = timesheetLog {
                let logIdString = String(log.logId!)
                contentBackgroundView.heroID = "\(logIdString).contentBackgroundView"
                cellBackgroundView.heroID = "\(logIdString).cellBackgroundView"
                dateBackgroundView.heroID = "\(logIdString).dateBackgroundView"
                dayLabel.heroID = "\(logIdString).dayLabel"
                dateLabel.heroID = "\(logIdString).dateLabel"
                timeInTitleLabel.heroID = "\(logIdString).timeInTitleLabel"
                timeInLabel.heroID = "\(logIdString).timeInLabel"
                timeOutTitleLabel.heroID = "\(logIdString).timeOutTitleLabel"
                timeOutLabel.heroID = "\(logIdString).timeOutLabel"
                
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
                dateBackgroundView.backgroundColor = color.foregroundColor
                dayLabel.textColor = color.backgroundColor
                dateLabel.textColor = color.backgroundColor
                
                contentBackgroundView.backgroundColor = color.backgroundColor
                timeInTitleLabel.textColor = color.foregroundColor
                timeInLabel.textColor = color.foregroundColor
                timeOutTitleLabel.textColor = color.foregroundColor
                timeOutLabel.textColor = color.foregroundColor
            }
        }
    }
    
    internal let contentBackgroundView = UIView()
    internal let dateBackgroundView = UIView()
    let cellBackgroundView = UIView()

    internal let dayLabel = UILabel()
    internal let dateLabel = UILabel()
    
    internal let timeInTitleLabel = UILabel()
    internal let timeInLabel = UILabel()

    internal let timeOutTitleLabel = UILabel()
    internal let timeOutLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let contentView = self
        
        contentBackgroundView.heroModifiers = [.duration(0.2), .cascade(direction: .bottomToTop, delayMatchedViews: false)]
        contentBackgroundView.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        contentBackgroundView.layer.masksToBounds = true
        contentBackgroundView.layer.cornerRadius = 8.0
        contentBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentBackgroundView)
        
        contentBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        contentBackgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5.0).isActive = true
        contentBackgroundView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5.0).isActive = true
        contentBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        // cellBackgroundView.heroModifiers = [.timingFunction(.easeInOut)]
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(cellBackgroundView)
        
        cellBackgroundView.heightAnchor.constraint(equalToConstant: TimesheetLogCell.height).isActive = true
        cellBackgroundView.topAnchor.constraint(equalTo: contentBackgroundView.topAnchor).isActive = true
        cellBackgroundView.leftAnchor.constraint(equalTo: contentBackgroundView.leftAnchor).isActive = true
        cellBackgroundView.rightAnchor.constraint(equalTo: contentBackgroundView.rightAnchor).isActive = true

        // setup day & date label
        dateBackgroundView.backgroundColor = UIColor.white
        dateBackgroundView.layer.masksToBounds = true
        dateBackgroundView.layer.cornerRadius = 8.0
        dateBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        cellBackgroundView.addSubview(dateBackgroundView)
        
        dateBackgroundView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: 5.0).isActive = true
        dateBackgroundView.leftAnchor.constraint(equalTo: cellBackgroundView.leftAnchor, constant: 5.0).isActive = true
        dateBackgroundView.widthAnchor.constraint(equalTo: dateBackgroundView.heightAnchor).isActive = true
        dateBackgroundView.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor, constant: -5.0).isActive = true
        
        dateLabel.textColor = UIColor.white
        dateLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        dateLabel.numberOfLines = 1
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateBackgroundView.addSubview(dateLabel)

        dayLabel.textColor = UIColor.white
        dayLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        dayLabel.numberOfLines = 1
        dayLabel.textAlignment = .center
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dateBackgroundView.addSubview(dayLabel)
        
        dateLabel.centerXAnchor.constraint(equalTo: dateBackgroundView.centerXAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: dateBackgroundView.centerYAnchor).isActive = true
        
        dayLabel.centerXAnchor.constraint(equalTo: dateBackgroundView.centerXAnchor).isActive = true
        dayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        
        // setup time in & out label
        let timeContentView = UIView()
        timeContentView.translatesAutoresizingMaskIntoConstraints = false
        cellBackgroundView.addSubview(timeContentView)
        
        timeInTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        timeInTitleLabel.textColor = UIColor.white
        timeInTitleLabel.numberOfLines = 1
        timeInTitleLabel.textAlignment = .center
        timeInTitleLabel.text = "IN"
        timeInTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeContentView.addSubview(timeInTitleLabel)
        
        timeInLabel.textColor = UIColor.white
        timeInLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        timeInLabel.textColor = UIColor.white
        timeInLabel.numberOfLines = 1
        timeInLabel.textAlignment = .center
        timeInLabel.translatesAutoresizingMaskIntoConstraints = false
        timeContentView.addSubview(timeInLabel)
        
        timeOutTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        timeOutTitleLabel.textColor = UIColor.white
        timeOutTitleLabel.numberOfLines = 1
        timeOutTitleLabel.textAlignment = .center
        timeOutTitleLabel.text = "OUT"
        timeOutTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeContentView.addSubview(timeOutTitleLabel)
        
        timeOutLabel.textColor = UIColor.white
        timeOutLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        timeOutLabel.textColor = UIColor.white
        timeOutLabel.numberOfLines = 1
        timeOutLabel.textAlignment = .center
        timeOutLabel.translatesAutoresizingMaskIntoConstraints = false
        timeContentView.addSubview(timeOutLabel)
        
        // setup constraints
        timeContentView.leftAnchor.constraint(equalTo: dateBackgroundView.rightAnchor, constant: 10.0).isActive = true
        timeContentView.rightAnchor.constraint(equalTo: cellBackgroundView.rightAnchor, constant: -10.0).isActive = true
        timeContentView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor).isActive = true
        timeContentView.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor).isActive = true

        timeInLabel.leftAnchor.constraint(equalTo: timeInTitleLabel.leftAnchor).isActive = true
        timeInLabel.rightAnchor.constraint(equalTo: timeInTitleLabel.rightAnchor).isActive = true
        timeInLabel.bottomAnchor.constraint(equalTo: timeContentView.centerYAnchor, constant: 4.0).isActive = true
      
        timeOutLabel.leftAnchor.constraint(equalTo: timeOutTitleLabel.leftAnchor).isActive = true
        timeOutLabel.rightAnchor.constraint(equalTo: timeOutTitleLabel.rightAnchor).isActive = true
        timeOutLabel.bottomAnchor.constraint(equalTo: timeContentView.centerYAnchor, constant: 4.0).isActive = true
        
        timeInTitleLabel.topAnchor.constraint(equalTo: timeInLabel.bottomAnchor).isActive = true
        timeInTitleLabel.leftAnchor.constraint(equalTo: timeContentView.leftAnchor).isActive = true
        timeInTitleLabel.rightAnchor.constraint(equalTo: timeContentView.centerXAnchor).isActive = true
        
        timeOutTitleLabel.topAnchor.constraint(equalTo: timeOutLabel.bottomAnchor).isActive = true
        timeOutTitleLabel.rightAnchor.constraint(equalTo: timeContentView.rightAnchor).isActive = true
        timeOutTitleLabel.leftAnchor.constraint(equalTo: timeContentView.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
