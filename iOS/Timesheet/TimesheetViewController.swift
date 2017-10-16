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
class TimesheetViewController: TimesheetBaseViewController {
    var timesheetCustomUser: TimesheetUser? { // only used in non-main areas (ex: sharing)
        didSet {
            OperationQueue.main.addOperation {
                self.timesheetLogs = nil
                self.timesheetSections = nil
                self.timesheetLogColors = [IndexPath: TimesheetColor]()
            
                self.timesheetLoading = false
                self.timesheetAdding = false
                self.timesheetCollectionView.reloadData()
                
                self.refreshFromRemoteBackend()
            }
        }
    }
    
    init(_ user: TimesheetUser? = nil) {
        timesheetCustomUser = user
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func authenticateFromRemoteBackend() {
        if timesheetCustomUser != nil {
            debugPrint("TimesheetViewController no need to authenticateFromRemoteBackend, timesheetCustomUser")
            self.refreshFromRemoteBackend()
        } else {
            super.authenticateFromRemoteBackend()
        }
    }
    
    override func refreshFromRemoteBackend() {
        guard timesheetCustomUser == nil else {
            timesheetLoading = true
            
            let friendManager = TimesheetFriendManager()
            _ = friendManager.getLogsFromFriend(friend: timesheetCustomUser!, { logs, error in
                if let validError = error {
                    showError(validError, from: self)
                    self.timesheetDone()
                    return
                }
                
                guard let validLogs = logs else {
                    debugPrint("refreshFromRemoteBackend() received nil response from dataManager logsFromRemoteDatabase")
                    showError(timesheetError(.noResponse), from: self)
                    self.timesheetDone()
                    return
                }
                
                self.sortLogs(validLogs)
            })
            
            return
        }
        
        super.refreshFromRemoteBackend()
    }
    
    override func signOutButtonTapped() {
        timesheetCustomUser = nil
        super.signOutButtonTapped()
    }
    
    override func rightButtonTapped() {
        if self.timesheetCustomUser == nil {
            let sharingViewController = TimesheetSharingViewController()
            sharingViewController.sharingSelectedUserCallback = { user in
                self.timesheetCustomUser = user
            }
            
            present(sharingViewController, animated: true, completion: nil)
        } else {
            self.timesheetCustomUser = nil
        }
    }

    // MARK: data source
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections = timesheetSections {
            return (timesheetCustomUser == nil ? 1 : 0) + sections.count  // add new item
        }
        
        return super.numberOfSections(in: collectionView)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 && timesheetCustomUser != nil {
            return 0
        }
        
        return super.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let expectedHeaderView = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) as? TimesheetHeaderView else {
            fatalError()
        }
        
        if indexPath.section == 0 && timesheetCustomUser != nil {
            expectedHeaderView.titleLabel.text = "Viewing \(timesheetCustomUser!.name!)."
        }
        
        return expectedHeaderView
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if timesheetCustomUser == nil {
            super.collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
}
