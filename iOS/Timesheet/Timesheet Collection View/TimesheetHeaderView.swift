//
//  TimesheetHeaderView.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/7/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

class TimesheetHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "TimesheetHeaderViewIdentifier"
    
    let titleLabel = UILabel()
    let underlineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        titleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        titleLabel.textColor = UIColor(white: 0.0, alpha: 0.6)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        addSubview(titleLabel)
        
        titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 10.0).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10.0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        underlineView.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underlineView)
        
        underlineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        underlineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        underlineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
