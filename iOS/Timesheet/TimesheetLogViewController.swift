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
    
    let cancelButton = UIButton()
    let saveButton = UIButton()
    let cellButton = UIButton()
    let originalCell = TimesheetLogCellView(frame: CGRect.zero)
    
    let controlsView = UIView()
    var timeControl = TenClock()
    
    let deleteButton = UIButton()
    var currentTask: URLSessionTask?

    var dismissCallback: (([TimesheetLog]?) -> Void)?
    
    init(_ log: TimesheetLog, _ color: TimesheetColor) {
        self.log = log.copy() as! TimesheetLog
        self.color = color
        
        super.init(nibName: nil, bundle: nil)
        
        isHeroEnabled = true
        // modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        
        // setup navigation bar buttons (save & cancel)
        let navigationBarHeight:CGFloat = 44.0
        let totalTopInset = navigationBarHeight + UIApplication.shared.statusBarFrame.height
        let navigationBar = UIView()
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
        navigationBar.addSubview(saveButton)
        
        saveButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -5.0).isActive = true
        saveButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -15).isActive = true

        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(cancelButton)
        
        cancelButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -5.0).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: 15).isActive = true

        // -- everything will now be inside of containerView --
        // setup original cell (with tap button)
        originalCell.timesheetLog = log
        originalCell.timesheetColor = color
        originalCell.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(originalCell)
        
        originalCell.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0).isActive = true
        originalCell.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5.0).isActive = true
        originalCell.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5.0).isActive = true
        originalCell.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100.0).isActive = true
        
        cellButton.translatesAutoresizingMaskIntoConstraints = false
        cellButton.addTarget(self, action: #selector(cellTapped), for: .touchUpInside)
        originalCell.addSubview(cellButton)
        
        cellButton.leftAnchor.constraint(equalTo: originalCell.cellBackgroundView.leftAnchor).isActive = true
        cellButton.rightAnchor.constraint(equalTo: originalCell.cellBackgroundView.rightAnchor).isActive = true
        cellButton.topAnchor.constraint(equalTo: originalCell.cellBackgroundView.topAnchor).isActive = true
        cellButton.bottomAnchor.constraint(equalTo: originalCell.cellBackgroundView.bottomAnchor).isActive = true
        
        // setup delete button
        deleteButton.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.setTitleColor(timesheetColor(name: "Red").backgroundColor, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.layer.cornerRadius = 8.0
        deleteButton.layer.masksToBounds = true
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        originalCell.addSubview(deleteButton)
        
        deleteButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        deleteButton.leftAnchor.constraint(equalTo: originalCell.leftAnchor, constant: 10.0).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: originalCell.rightAnchor, constant: -10.0).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: originalCell.bottomAnchor, constant: -5.0).isActive = true
        
        // setup controls view, clock
        controlsView.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        controlsView.layer.masksToBounds = true
        controlsView.layer.cornerRadius = 8.0
        controlsView.clipsToBounds = true
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        originalCell.addSubview(controlsView)
        
        controlsView.topAnchor.constraint(equalTo: originalCell.cellBackgroundView.bottomAnchor, constant: 5.0).isActive = true
        controlsView.leftAnchor.constraint(equalTo: originalCell.leftAnchor, constant: 10.0).isActive = true
        controlsView.rightAnchor.constraint(equalTo: originalCell.rightAnchor, constant: -10.0).isActive = true
        controlsView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -5.0).isActive = true
        
        setupTimeControl()
    }
    
    // MARK: - actions
    func saveButtonTapped() {
        saveButton.isEnabled = false
        saveButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2) {
            self.saveButton.alpha = 0.1
        }
        
        let dataManager = TimesheetDataManager()
        currentTask = dataManager.editLogInRemoteDatabase(log: log) { logs, error in
            if let validError = error {
                showError(validError, from: self)
                
                OperationQueue.main.addOperation {
                    self.saveButton.isEnabled = true
                    self.saveButton.isUserInteractionEnabled = true
                    self.saveButton.alpha = 1.0
                }
                
                return
            }
            
            self.dismissCallback?(logs)
        }
    }
    
    func cancelButtonTapped() {
        currentTask?.cancel()
        dismiss(animated: true, completion: nil)
    }
    
    func deleteButtonTapped() {
        deleteButton.isEnabled = false
        saveButton.isEnabled = false
        
        UIView.animate(withDuration: 0.2) {
            self.deleteButton.alpha = 0.1
            self.saveButton.alpha = 0.1
        }
        
        let dataManager = TimesheetDataManager()
        currentTask = dataManager.deleteLogInRemoteDatabase(log: log) { logs, error in
            if let validError = error {
                showError(validError, from: self)
                
                self.deleteButton.isEnabled = true
                self.saveButton.isEnabled = true
                OperationQueue.main.addOperation {
                    self.deleteButton.alpha = 1.0
                    self.saveButton.alpha = 1.0
                }
                
                return
            }
            
            self.dismissCallback?(logs)
        }
    }
    
    func cellTapped() {
        let dialog = DatePickerDialog(textColor: UIColor.black, buttonColor: color.foregroundColor, font: UIFont.systemFont(ofSize: 20.0, weight: .medium), locale: Locale.current, showCancelButton: true)
        dialog.show("Change Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: log.timeIn!, minimumDate: nil, maximumDate: nil, datePickerMode: .date, callback: { (date) in
            if let validDate = date {
                let newYearComponent = Calendar.current.component(.year, from: validDate)
                let newMonthComponent = Calendar.current.component(.month, from: validDate)
                let newDayComponent = Calendar.current.component(.day, from: validDate)
                
                var newTimeInComponents = Calendar.current.dateComponents(timesheetDateComponents, from: self.log.timeIn!)
                newTimeInComponents.year = newYearComponent
                newTimeInComponents.month = newMonthComponent
                newTimeInComponents.day = newDayComponent
                let newTimeIn = newTimeInComponents.date
                self.log.timeIn = newTimeIn
                
                var newTimeOutComponents = Calendar.current.dateComponents(timesheetDateComponents, from: self.log.timeOut!)
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
        
        timeControl.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor).isActive = true
        timeControl.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor).isActive = true
        timeControl.widthAnchor.constraint(equalTo: controlsView.widthAnchor, constant: -20.0).isActive = true
        timeControl.heightAnchor.constraint(equalTo: timeControl.widthAnchor, constant: -20.0).isActive = true
    }
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
        var newTimeInComponent = Calendar.current.dateComponents(timesheetDateComponents, from: log.timeIn!)
        newTimeInComponent.hour = newInHourComponent
        newTimeInComponent.minute = newInMinuteComponent
        log.timeIn = newTimeInComponent.date!
        
        let newOutHourComponent = Calendar.current.component(.hour, from: endDate)
        let newOutMinuteComponent = Calendar.current.component(.minute, from: endDate)
        var newTimeOutComponent = Calendar.current.dateComponents(timesheetDateComponents, from: log.timeOut!)
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
