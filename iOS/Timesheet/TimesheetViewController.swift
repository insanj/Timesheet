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
    let timesheetNavigationBar = TimesheetNavigationBar()
    let timesheetCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var timesheetLoading = false
    
    var timesheetSections: [Date]?
    var timesheetLogs: [[TimesheetLog]]?
    var timesheetLogColors = [IndexPath: TimesheetColor]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup view
        view.backgroundColor = UIColor.white
        
        // setup contents
        setupCollectionView()
        
        // setup navigation bar
        timesheetNavigationBar.titleLabel.text = "Timesheet"
        timesheetNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timesheetNavigationBar)
        
        timesheetNavigationBar.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        timesheetNavigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        timesheetNavigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        timesheetNavigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        // navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
        // navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
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
        timesheetCollectionView.backgroundColor = UIColor.clear
        timesheetCollectionView.delegate = self
        timesheetCollectionView.dataSource = self
        
        timesheetCollectionView.register(TimesheetHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: TimesheetHeaderView.reuseIdentifier)
        timesheetCollectionView.register(TimesheetLogCell.self, forCellWithReuseIdentifier: TimesheetLogCell.reuseIdentifier)
        
        timesheetCollectionView.alwaysBounceVertical = true
        
        timesheetCollectionView.contentInset = UIEdgeInsets(top: 64.0, left: 0, bottom: 0, right: 0)
        
        timesheetCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timesheetCollectionView)
        
        timesheetCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        timesheetCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        timesheetCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        timesheetCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
            assert($0.timeIn != nil && $1.timeIn != nil, "Cannot properly sort log entries of some do not have valid dates")
            return $0.timeIn!.compare($1.timeIn!) == .orderedAscending
        }
        
        var logsByMonth = [[TimesheetLog]]()
        var logDates = [Date]()
        
        var currentMonth: Int = -1
        var currentYear: Int = -1
        
        let calendar = Calendar.current
        
        for log in sortedLogs {
            let logDate = log.timeIn!
            let logMonth = calendar.component(.month, from: logDate)
            let logYear = calendar.component(.year, from: logDate)
            
            if logMonth == currentMonth && logYear == currentYear {
                if var existingLogs = logsByMonth.last {
                    existingLogs.append(log)
                    logsByMonth[logsByMonth.count-1] = existingLogs
                } else {
                    logsByMonth.append([log])
                }
            } else {
                currentMonth = logMonth
                currentYear = logYear
                
                logDates.append(logDate)
                logsByMonth.append([log])
            }
        }
        
        timesheetLogs = logsByMonth
        timesheetSections = logDates
        
        timesheetLogColors = [IndexPath: TimesheetColor]()
        
        // finally done!
        DispatchQueue.main.sync {
            self.timesheetLoading = false
            self.navigationItem.prompt = nil
            self.timesheetCollectionView.reloadData()
        }
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
        let width = min(view.frame.size.width, collectionView.frame.size.width - 10.0) // the item width must be less than the width of the UICollectionView minus the section insets left and right values, minus the content insets left and right values
        return CGSize(width: width, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 30.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TimesheetHeaderView.reuseIdentifier, for: indexPath) as? TimesheetHeaderView else {
                fatalError()
            }
            
            if let sections = timesheetSections {
                let date = sections[indexPath.section]
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM yyyy"
                headerView.titleLabel.text = dateFormatter.string(from: date)
            } else {
                headerView.titleLabel.text = "Loading..."
            }
            
            return headerView
        }
        
        fatalError()
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
        
        if let existingColor = timesheetLogColors[indexPath] {
            cell.timesheetColor = existingColor
        } else {
            let color = timesheetRandomColor()
            cell.timesheetColor = color
            timesheetLogColors[indexPath] = color
        }
        
        return cell
    }
}

// MARK: delegate
extension TimesheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
