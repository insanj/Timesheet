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
    var timesheetData: [[TimesheetLog]]?
    var timesheetLoading = false
    
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
        
        if timesheetData == nil {
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
        
        
    }
    
    func refreshFromLocalBackend() {

    }
    
    // MARK: - actions
    func refreshButtonTapped() {
        
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = timesheetData {
            return data.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

// MARK: delegate
extension TimesheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
