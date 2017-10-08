//
//  TimesheetLogViewController.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/7/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

@objcMembers
class TimesheetLogViewController: UIViewController {
    let log: TimesheetLog
    let color: TimesheetColor
    
    let containerView = UIView()
    let cancelButton = UIButton()
    let saveButton = UIButton()
    let originalCell = TimesheetLogCell(frame: CGRect.zero)
    let controlsView = UIView()
    
    init(_ log: TimesheetLog, _ color: TimesheetColor) {
        self.log = log
        self.color = color
        
        super.init(nibName: nil, bundle: nil)
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        containerView.backgroundColor = UIColor.clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -200.0).isActive = true
        
        saveButton.setTitleColor(UIColor.black, for: .normal)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        
        saveButton.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -5.0).isActive = true
        saveButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -15).isActive = true

        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
        cancelButton.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -5.0).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15).isActive = true
        
        originalCell.timesheetLog = log
        originalCell.timesheetColor = color
        originalCell.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(originalCell)
        
        originalCell.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        originalCell.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        originalCell.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        originalCell.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        controlsView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        controlsView.layer.masksToBounds = true
        controlsView.layer.cornerRadius = 8.0
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controlsView)
        
        controlsView.topAnchor.constraint(equalTo: originalCell.bottomAnchor, constant: 5.0).isActive = true
        controlsView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5.0).isActive = true
        controlsView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5.0).isActive = true
        controlsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    func saveButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
