//
//  TimesheetLogViewController.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/7/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit
import TenClock
import DatePickerDialog

@objcMembers
class TimesheetLogViewController: UIViewController {
    var log: TimesheetLog
    var color: TimesheetColor
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    let cancelButton = UIButton()
    let saveButton = UIButton()
    let cellButton = UIButton()
    let originalCell = TimesheetLogCell(frame: CGRect.zero)
    
    let controlsView = UIView()
    var timeControl = TenClock()
    
    var saveCallback: (([TimesheetLog]?) -> Void)?
    var saveTask: URLSessionTask?
    
    init(_ log: TimesheetLog, _ color: TimesheetColor) {
        self.log = log.copy() as! TimesheetLog
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
        
        // setup background view
        let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        // setup navigation bar buttons (save & cancel)
        let navigationBarHeight:CGFloat = 44.0
        let totalTopInset = navigationBarHeight + UIApplication.shared.statusBarFrame.height
        let navigationBar = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: totalTopInset).isActive = true

        saveButton.setTitleColor(UIColor.black, for: .normal)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.contentView.addSubview(saveButton)
        
        saveButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -5.0).isActive = true
        saveButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -15).isActive = true

        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.contentView.addSubview(cancelButton)
        
        cancelButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -5.0).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: 15).isActive = true
        
        // setup scroll view (with container inside of it)
        scrollView.contentInset = UIEdgeInsets(top: navigationBarHeight, left: 0, bottom: 0, right: 0)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: navigationBarHeight, left: 0, bottom: 0, right: 0)
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(scrollView, belowSubview: navigationBar)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView.backgroundColor = UIColor.clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        // -- everything will now be inside of containerView --
        // setup original cell (with tap button)
        originalCell.timesheetLog = log
        originalCell.timesheetColor = color
        originalCell.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(originalCell)
        
        originalCell.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        originalCell.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        originalCell.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        originalCell.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        cellButton.translatesAutoresizingMaskIntoConstraints = false
        cellButton.addTarget(self, action: #selector(cellTapped), for: .touchUpInside)
        containerView.addSubview(cellButton)
        
        cellButton.leftAnchor.constraint(equalTo: originalCell.leftAnchor).isActive = true
        cellButton.rightAnchor.constraint(equalTo: originalCell.rightAnchor).isActive = true
        cellButton.topAnchor.constraint(equalTo: originalCell.topAnchor).isActive = true
        cellButton.bottomAnchor.constraint(equalTo: originalCell.bottomAnchor).isActive = true

        // setup controls view, clock
        controlsView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        controlsView.layer.masksToBounds = true
        controlsView.layer.cornerRadius = 8.0
        controlsView.clipsToBounds = true
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controlsView)
        
        controlsView.topAnchor.constraint(equalTo: originalCell.bottomAnchor, constant: 5.0).isActive = true
        controlsView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5.0).isActive = true
        controlsView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5.0).isActive = true
        controlsView.heightAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        setupTimeControl()
    }
    
    func saveButtonTapped() {
        let loadingAlert = UIAlertController(title: "Saving...", message: nil, preferredStyle: .alert)
        
        loadingAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.saveTask?.cancel()
        }))
        
        present(loadingAlert, animated: true, completion: nil)
        
        let dataManager = TimesheetDataManager()
        dataManager.editLogInRemoteDatabase(log: log) { logs, error in
            loadingAlert.dismiss(animated: true, completion: nil)
            
            if let validError = error {
                showError(validError, from: self)
                return
            }
            
            self.saveCallback?(logs)
        }
    }
    
    func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func cellTapped() {
        let dialog = DatePickerDialog(textColor: UIColor.black, buttonColor: color.foregroundColor, font: UIFont.systemFont(ofSize: 20.0, weight: .medium), locale: Locale.current, showCancelButton: true)
        dialog.show("Change Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: log.timeIn!, minimumDate: nil, maximumDate: nil, datePickerMode: .date, callback: { (date) in
            if let validDate = date {
                let newYearComponent = Calendar.current.component(.year, from: validDate)
                let newMonthComponent = Calendar.current.component(.month, from: validDate)
                let newDayComponent = Calendar.current.component(.day, from: validDate)
                
                var newTimeInComponents = Calendar.current.dateComponents(in: TimeZone.current, from: self.log.timeIn!)
                newTimeInComponents.year = newYearComponent
                newTimeInComponents.month = newMonthComponent
                newTimeInComponents.day = newDayComponent
                let newTimeIn = newTimeInComponents.date
                self.log.timeIn = newTimeIn
                
                var newTimeOutComponents = Calendar.current.dateComponents(in: TimeZone.current, from: self.log.timeOut!)
                newTimeOutComponents.year = newYearComponent
                newTimeOutComponents.month = newMonthComponent
                newTimeOutComponents.day = newDayComponent
                let newTimeOut = newTimeOutComponents.date
                self.log.timeOut = newTimeOut
                
                let newColor = timesheetColor(day: newTimeInComponents.day!)
                self.color = newColor
                
                self.originalCell.timesheetColor = newColor
                self.originalCell.timesheetLog = self.log
                
                // manually force timeControl to change because it fails to update properly on its own
                self.timeControl.removeFromSuperview()
                self.timeControl = TenClock()
                self.setupTimeControl()
            }
        })
    }
    
    func setupTimeControl() {
        timeControl.headText = "IN"
        timeControl.tailText = "OUT"
        timeControl.startDate = log.timeIn!
        timeControl.endDate = log.timeOut!
        timeControl.centerTextColor = color.foregroundColor
        timeControl.tintColor = color.backgroundColor
        timeControl.majorTicksColor = UIColor.white
        timeControl.delegate = self
        timeControl.translatesAutoresizingMaskIntoConstraints = false
        controlsView.addSubview(timeControl)
        
        timeControl.leftAnchor.constraint(equalTo: controlsView.leftAnchor).isActive = true
        timeControl.rightAnchor.constraint(equalTo: controlsView.rightAnchor).isActive = true
        timeControl.topAnchor.constraint(equalTo: controlsView.topAnchor).isActive = true
        timeControl.bottomAnchor.constraint(equalTo: controlsView.bottomAnchor).isActive = true
    }
    
    // UIScrollViewDelegate extension
    var dismissWaiting = false
}

extension TimesheetLogViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewOffset = scrollView.contentOffset.y + scrollView.contentInset.top + UIApplication.shared.statusBarFrame.height
        
        if scrollViewOffset < 0 {
            let offset = abs(scrollViewOffset)
            
            if offset >= 90 { // 10 extra because animating to 0.1, not 0.0 alpha
                view.alpha = 0.1 // done
            } else {
                view.alpha = 1.0 - (offset / 100.0) // progress
            }
        } else {
            view.alpha = 1.0 // nothing
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollViewOffset = scrollView.contentOffset.y + scrollView.contentInset.top + UIApplication.shared.statusBarFrame.height
        if scrollViewOffset < -100.0 {
            dismiss(animated: false, completion: nil)
        }
    }
}

extension TimesheetLogViewController: TenClockDelegate {
    func timesUpdated(_ clock: TenClock, startDate: Date, endDate: Date) {
        let newInHourComponent = Calendar.current.component(.hour, from: startDate)
        let newInMinuteComponent = Calendar.current.component(.minute, from: startDate)
        var newTimeInComponent = Calendar.current.dateComponents(in: TimeZone.current, from: log.timeIn!)
        newTimeInComponent.hour = newInHourComponent
        newTimeInComponent.minute = newInMinuteComponent
        log.timeIn = newTimeInComponent.date!
        
        let newOutHourComponent = Calendar.current.component(.hour, from: endDate)
        let newOutMinuteComponent = Calendar.current.component(.minute, from: endDate)
        var newTimeOutComponent = Calendar.current.dateComponents(in: TimeZone.current, from: log.timeOut!)
        newTimeOutComponent.hour = newOutHourComponent
        newTimeOutComponent.minute = newOutMinuteComponent
        log.timeOut = newTimeOutComponent.date!
        
        let newColor = timesheetColor(day: newTimeInComponent.day!)
        color = newColor
        
        originalCell.timesheetColor = newColor
        originalCell.timesheetLog = log
        clock.centerTextColor = newColor.foregroundColor
        clock.tintColor = newColor.backgroundColor
    }
}
