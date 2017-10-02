//
//  TimesheetViewController.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/1/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

@objcMembers
class TimesheetViewController: UIViewController {
    let timesheetCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var timesheetLoading = false
    var timesheetSections: [String]?
    var timesheetLogs: [[TimesheetLog]]?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup navigation controller
        title = "Timesheet"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))

        // setup view
        view.backgroundColor = UIColor(red:0.161, green:0.169, blue:0.212, alpha:1.00)
        
        // setup contents
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if timesheetLogs == nil {
            refreshFromRemoteBackend()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - setup
    func setupCollectionView() {
        timesheetCollectionView.delegate = self
        timesheetCollectionView.dataSource = self
        
        timesheetCollectionView.register(TimesheetLogCell.self, forCellWithReuseIdentifier: TimesheetLogCell.reuseIdentifier)
    }
    
    func refreshFromRemoteBackend() {
        if timesheetLoading == true {
            debugPrint("refreshFromRemoteBackend() called but timesheetLoading already == true")
            return
        }
        
        timesheetLoading = true
        navigationItem.prompt = "Refreshing..."
        
        let dataManager = TimesheetDataManager()
        dataManager.logsFromRemoteDatabase { (logs) in
            guard let validLogs = logs else {
                debugPrint("refreshFromRemoteBackend() received nil response from dataManager logsFromRemoteDatabase")
                self.timesheetLoading = false
                return
            }
            
            self.sortLogs(validLogs)
        }
    }
    
    func sortLogs(_ logs: [TimesheetLog]) {
        let sortedLogs = logs.sorted {
            assert($0.created != nil && $1.created != nil, "Cannot properly sort log entries of some do not have valid dates")
            return $0.created!.compare($1.created!) == .orderedAscending
        }
        
        var logsByMonth = [[TimesheetLog]]()
        var logMonths = [Int]()
        var currentMonth: Int = -1
        let calendar = Calendar.current
        
        for log in sortedLogs {
            let logMonth = calendar.component(.month, from: log.created!)
            if logMonth == currentMonth {
                if var existingLogs = logsByMonth.last {
                    existingLogs.append(log)
                } else {
                    logsByMonth.append([log])
                }
            } else {
                currentMonth = logMonth
                logMonths.append(logMonth)
                
                logsByMonth.append([log])
            }
        }
        
        timesheetLogs = logsByMonth
        timesheetSections = logMonths.flatMap { return String($0) }
        
        // finally done!
        timesheetLoading = false
        navigationItem.prompt = nil
        timesheetCollectionView.reloadData()
    }
    
    // MARK: - actions
    func refreshButtonTapped() {
        refreshFromRemoteBackend()
    }
    
    func addButtonTapped() {
        
    }
}

// MARK: - collection view
// MARK: layout
extension TimesheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
    }
}

// MARK: data source
extension TimesheetViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections = timesheetSections {
            return sections.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let logsByMonth = timesheetLogs {
            return logsByMonth[section].count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimesheetLogCell.reuseIdentifier, for: indexPath) as? TimesheetLogCell else {
            debugPrint("cellForItemAt unable to dequeueReusableCell as TimesheetLogCell")
            fatalError()
        }
        
        guard let logs = timesheetLogs else {
            debugPrint("cellForItemAt called for indexPath \(indexPath.debugDescription) with no suitable timesheet log")
            fatalError()
        }
        
        cell.timesheetLog = logs[indexPath.section][indexPath.row]
        return cell
    }
}

// MARK: delegate
extension TimesheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
