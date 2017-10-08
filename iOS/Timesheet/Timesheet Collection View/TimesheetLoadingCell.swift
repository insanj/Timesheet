//
//  TimesheetLoadingCell.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/7/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

class TimesheetLoadingCell: UICollectionViewCell {
    static let reuseIdentifier: String = "TimesheetLoadingCellIdentifier"
    
    internal let contentBackgroundView = UIView()
    internal let indicatorView = UIActivityIndicatorView()
    internal let detailLabel = UILabel()
    
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
        
        indicatorView.color = UIColor(white: 0.0, alpha: 0.6)
        indicatorView.hidesWhenStopped = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(indicatorView)
        
        indicatorView.centerYAnchor.constraint(equalTo: contentBackgroundView.centerYAnchor, constant: -10.0).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: contentBackgroundView.centerXAnchor).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        indicatorView.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        detailLabel.textColor = UIColor(white: 0.0, alpha: 0.6)
        detailLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        detailLabel.text = "Loading..."
        detailLabel.numberOfLines = 1
        detailLabel.textAlignment = .center
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addSubview(detailLabel)
        
        detailLabel.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 5.0).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: contentBackgroundView.leftAnchor, constant: 10.0).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: contentBackgroundView.rightAnchor, constant: -10.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
