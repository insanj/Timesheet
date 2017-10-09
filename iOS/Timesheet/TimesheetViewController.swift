//
//  TimesheetViewController.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/1/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit
import BulletinBoard

@objcMembers
class TimesheetViewController: UIViewController {
    var timesheetUser: TimesheetUser?
    
    let timesheetNavigationBar = TimesheetNavigationBar()

    let timesheetCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var timesheetLoading = false {
        didSet {
            OperationQueue.main.addOperation {
                self.refreshNavigationBarDetailLabel()
            }
        }
    }
    
    var timesheetAdding = false {
        willSet {
            if newValue != timesheetAdding {
                let indexPath = IndexPath(item: 0, section: 0)

                OperationQueue.main.addOperation {
                    self.timesheetCollectionView.reloadItems(at: [indexPath])
                }
            }
        }
    }
    
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
        
        /*_ = TimesheetDataManager().createAccountInRemoteDatabase(email: "insanj@gmail.com", password: "testing") { (response, error) in
            debugPrint("createAccountInRemoteDatabase response = \(response.debugDescription)")
        }*/
        
        isHeroEnabled = true

        // setup view
        view.backgroundColor = UIColor.white
        
        // setup contents
        setupCollectionView()
        
        // setup navigation bar
        timesheetNavigationBar.titleLabel.text = "Timesheet"
        timesheetNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timesheetNavigationBar)
    
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
        timesheetCollectionView.register(TimesheetAddLogCell.self, forCellWithReuseIdentifier: TimesheetAddLogCell.reuseIdentifier)
        timesheetCollectionView.register(TimesheetLoadingCell.self, forCellWithReuseIdentifier: TimesheetLoadingCell.reuseIdentifier)
        timesheetCollectionView.register(TimesheetLogCell.self, forCellWithReuseIdentifier: TimesheetLogCell.reuseIdentifier)
        
        timesheetCollectionView.alwaysBounceVertical = true
        
        let topInset = (timesheetNavigationBar.navigationBarHeight - UIApplication.shared.statusBarFrame.height) + 5.0
        timesheetCollectionView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        timesheetCollectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        
        timesheetCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timesheetCollectionView)

        timesheetCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        timesheetCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        timesheetCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        timesheetCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func authenticateFromRemoteBackend() {
        let userManager = TimesheetUserManager()
        userManager.keychainAuthenticate(self) { (user) in
            if let validUser = user {
                self.timesheetUser = validUser
                self.refreshFromRemoteBackend()
            } else {
                self.showAuthenticationBulletinBoard()
            }
        }
    }
    
    func login(email: String, password: String) {
        let userManager = TimesheetUserManager()
        _ = userManager.loginInRemoteDatabase(email: email, password: password) { (user, error) in
            if let validUser = user {
                self.timesheetUser = validUser
                
                TimesheetUser.currentEmail = email
                TimesheetUser.currentPassword = password
                TimesheetUser.currentName = validUser.name

                self.refreshFromRemoteBackend()
            } else if let validError = error {
                showError(validError, from: self)
            } else {
                showError(timesheetError(.noResponse), from: self)

            }
        }
    }
    
    var authenticationBulletinManager: BulletinManager?

    let authenticationWelcomeBulletinItem: PageBulletinItem = {
        let page = PageBulletinItem(title: "Welcome 👋")
        page.image = UIImage(named: "iTunesArtwork")
        page.descriptionText = "Thanks for downloading Timesheet, a fun and creative way to keep track of your time. Tap below to save a whole bunch of time!"
        page.actionButtonTitle = "Start"
        page.alternativeButtonTitle = "Learn More"
        return page
    }()

    let authenticationLoginBulletinItem: PageBulletinItem = {
        let page = PageBulletinItem(title: "Get Started")
        page.actionButtonTitle = "Sign In"
        page.alternativeButtonTitle = "Create New Account"
        return page
    }()
    
    func showAuthenticationBulletinBoard() {
        // setup handlers
        // -- 1st
        authenticationWelcomeBulletinItem.actionHandler = { item in
            self.authenticationBulletinManager!.push(item: self.authenticationLoginBulletinItem)
        }
        
        authenticationWelcomeBulletinItem.alternativeHandler = { item in
            
        }
        
        // -- 2nd
        authenticationLoginBulletinItem.actionHandler = { item in
            let authenticationPopup = UIAlertController(title: "Sign In", message: nil, preferredStyle: .alert)
            authenticationPopup.addTextField(configurationHandler: { textField in
                textField.placeholder = "email"
                textField.keyboardType = .emailAddress
            })
            
            authenticationPopup.addTextField(configurationHandler: { textField in
                textField.placeholder = "password"
                textField.isSecureTextEntry = true
            })
            
            authenticationPopup.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
                
            }))
            
            authenticationPopup.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(authenticationPopup, animated: true, completion: nil)
        }
        
        authenticationLoginBulletinItem.alternativeHandler = { item in
            
        }
        
        let bulletin = BulletinManager(rootItem: authenticationWelcomeBulletinItem)
        bulletin.prepare()
        bulletin.presentBulletin(above: self)

        authenticationBulletinManager = bulletin
    }
    
    func refreshFromRemoteBackend() {
        guard timesheetUser != nil else {
            authenticateFromRemoteBackend()
            return
        }
        
        guard !timesheetLoading && !timesheetAdding else {
            debugPrint("refreshFromRemoteBackend() called but timesheetLoading or timesheetAdding == true")
            return
        }
        
        timesheetLoading = true
        
        let dataManager = TimesheetDataManager()
        _ = dataManager.logsFromRemoteDatabase { logs, error in
            if let validError = error {
                showError(validError, from: self)
                return
            }
            
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
            return $0.timeIn!.compare($1.timeIn!) == .orderedDescending
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
            self.timesheetAdding = false
            self.timesheetCollectionView.reloadData()
        }
    }
    
    func addTimesheetLog() {
        guard !timesheetAdding && !timesheetLoading else {
            print("addTimesheetLog() timesheetAdding == true, doing nothing...")
            return
        }
        
        timesheetAdding = true
        
        var defaultTimeInComponents = Calendar.current.dateComponents(timesheetDateComponents, from: Date())
        
        defaultTimeInComponents.hour = 9 // TODO: default time valies
        defaultTimeInComponents.minute = 0
        let defaultTimeIn = defaultTimeInComponents.date ?? Date()
        
        defaultTimeInComponents.hour = 17
        defaultTimeInComponents.minute = 0
        let defaultTimeOut = defaultTimeInComponents.date ?? Date()

        let dataManager = TimesheetDataManager()
        _ = dataManager.addLogToRemoteDatabase(timeIn: defaultTimeIn, timeOut: defaultTimeOut) { logs, error in
            if let validError = error {
                showError(validError, from: self)
                return
            }
            
            guard let validLogs = logs else {
                debugPrint("addTimesheetLog() received nil response from dataManager logsFromRemoteDatabase")
                self.timesheetAdding = false
                return
            }
            
            self.sortLogs(validLogs)
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
            return 1 + sections.count  // add new item
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if let logsByMonth = timesheetLogs {
            return logsByMonth[section-1].count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TimesheetHeaderView.reuseIdentifier, for: indexPath) as? TimesheetHeaderView else {
                fatalError()
            }
            
            if indexPath.section == 0 {
                let currentHour = Calendar.current.component(.hour, from: Date())
                var friendlyString = "Day" // TODO: localize
                if currentHour < 12 {
                    friendlyString = "Morning"
                } else if currentHour < 5 {
                    friendlyString = "Afternoon"
                } else {
                    friendlyString = "Evening"
                }
                
                let userString = "Julian" // TODO: user accounts
                
                headerView.titleLabel.text = "Good \(friendlyString), \(userString)."
            } else if let sections = timesheetSections {
                let date = sections[indexPath.section-1]
                
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
        guard indexPath.section > 0 else {
            if !timesheetAdding {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimesheetAddLogCell.reuseIdentifier, for: indexPath)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimesheetLoadingCell.reuseIdentifier, for: indexPath) as? TimesheetLoadingCell else {
                    fatalError()
                }
                
                cell.indicatorView.startAnimating()
                cell.detailLabel.text = "Adding..."
                
                return cell
            }
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimesheetLogCell.reuseIdentifier, for: indexPath) as? TimesheetLogCell else {
            debugPrint("cellForItemAt unable to dequeueReusableCell as TimesheetLogCell")
            fatalError()
        }
        
        guard let logs = timesheetLogs else {
            debugPrint("cellForItemAt called for indexPath \(indexPath.debugDescription) with no suitable timesheet log")
            fatalError()
        }
        
        let log = logs[indexPath.section-1][indexPath.row]
        cell.timesheetLog = log
        
        if let existingColor = timesheetLogColors[indexPath] {
            cell.timesheetColor = existingColor
        } else {
            let day = Calendar.current.component(.day, from: log.timeIn!)
            let color = timesheetColor(day: day)
            
            cell.timesheetColor = color
            timesheetLogColors[indexPath] = color
        }
        
        return cell
    }
}

// MARK: delegate
extension TimesheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            addTimesheetLog()
        } else if let logs = timesheetLogs {
            let log = logs[indexPath.section-1][indexPath.row]
            let color = timesheetLogColors[indexPath]!
            let logViewController = TimesheetLogViewController(log, color)
            logViewController.dismissCallback = { logs in
                logViewController.dismiss(animated: true, completion: nil)
                if let validLogs = logs {
                    self.sortLogs(validLogs)
                }
            }
            
            present(logViewController, animated: true, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshNavigationBarDetailLabel()
    }

    func refreshNavigationBarDetailLabel() {
        guard !timesheetLoading else {
            timesheetNavigationBar.detailLabel.alpha = 1.0
            timesheetNavigationBar.detailLabel.text = "Refreshing..."
            return
        }
        
        let scrollView = timesheetCollectionView
        let scrollViewOffset = scrollView.contentOffset.y + scrollView.contentInset.top + UIApplication.shared.statusBarFrame.height
        // print("offset = \(scrollViewOffset)")
        
        if scrollViewOffset < 0 {
            let offset = abs(scrollViewOffset)
            
            if offset > 100 {
                // done
                timesheetNavigationBar.detailLabel.alpha = 1.0
                timesheetNavigationBar.detailLabel.text = "Release to refresh"
            } else {
                // progress
                timesheetNavigationBar.detailLabel.alpha = offset / 100.0
                timesheetNavigationBar.detailLabel.text = "Pull to refresh"
            }
        } else {
            // nothing
            timesheetNavigationBar.detailLabel.alpha = 0.0
            timesheetNavigationBar.detailLabel.text = nil
            
            if scrollViewOffset > view.frame.size.height { // arbitrary, but a whole "page" length
                timesheetNavigationBar.showingHandle = false
            } else {
                timesheetNavigationBar.showingHandle = true
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollViewOffset = scrollView.contentOffset.y + scrollView.contentInset.top + UIApplication.shared.statusBarFrame.height
        if scrollViewOffset < -100.0 {
            refreshFromRemoteBackend()
        }
    }
}
