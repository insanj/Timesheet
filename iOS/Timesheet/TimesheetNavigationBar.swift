//
//  TimesheetNavigationBar.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/7/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

class TimesheetNavigationBar: UIView {
    
    let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let titleLabel = UILabel()
    let detailLabel = UILabel()

    init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.clear
        
        // setup background view
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 12.0
        backgroundView.layer.borderWidth = 1.0
        backgroundView.layer.borderColor = UIColor(white: 0.0, alpha: 0.1).cgColor
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: -10.0).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: -1.0).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: 1.0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // setup detail label
        detailLabel.textColor = UIColor(white:0.0, alpha: 0.6)
        detailLabel.textAlignment = .center
        detailLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        detailLabel.numberOfLines = 1
        detailLabel.setContentHuggingPriority(.required, for: .vertical)
        detailLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(detailLabel)
        
        detailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true

        // setup title label
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        titleLabel.bottomAnchor.constraint(equalTo: detailLabel.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
