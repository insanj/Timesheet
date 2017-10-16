//
//  TimesheetSharingViewController.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/11/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

@objcMembers
class TimesheetSharingViewController: UIViewController {
    let cancelButton = TimesheetButton(timesheetColor(name: "Olive"))
    let headerView = TimesheetSharingHeaderView()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var sharingAcceptedFriends: [TimesheetFriendRequest]?
    var sharingPendingRequests: [TimesheetFriendRequest]?
    
    var sharingCurrentDataSource: [TimesheetFriendRequest]? {
        return headerView.segmentedControl.selectedSegmentIndex == 0 ? sharingAcceptedFriends : sharingPendingRequests
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        isHeroEnabled = true
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        view.heroModifiers = [.fade]
        
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
        
        cancelButton.heroModifiers = [.fade, .translate(x: 0, y: -50.0, z: 0.0)]
        cancelButton.setTitle("    Cancel    ", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(cancelButton)
        
        cancelButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -5.0).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: 15).isActive = true
        
        // setup header view
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        headerView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 15).isActive = true

        // setup collection view
        // collectionView.heroModifiers = [.fade, .translate(x: 0, y: view.frame.size.height / 2.0, z: 0)]
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        collectionView.register(TimesheetLoadingCell.self, forCellWithReuseIdentifier: TimesheetLoadingCell.reuseIdentifier)
        collectionView.register(TimesheetAddLogCell.self, forCellWithReuseIdentifier: TimesheetAddLogCell.reuseIdentifier)
        collectionView.register(TimesheetSharingFriendRequestCell.self, forCellWithReuseIdentifier: TimesheetSharingFriendRequestCell.reuseIdentifier)

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: headerView.lastViewBottomAnchor, constant: 10.0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension TimesheetSharingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = min(view.frame.size.width, collectionView.frame.size.width - 10.0)
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

extension TimesheetSharingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if let requests = sharingCurrentDataSource {
            return requests.count
        } else {
            return 1 // loading cell
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimesheetAddLogCell.reuseIdentifier, for: indexPath) as? TimesheetAddLogCell else {
                fatalError()
            }
            
            cell.addDetailLabel.text = "Tap to add a new friend"
            
            return cell
        }
        
        if let requests = sharingCurrentDataSource {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimesheetSharingFriendRequestCell.reuseIdentifier, for: indexPath) as? TimesheetSharingFriendRequestCell else {
                fatalError()
            }
            
            cell.friendRequest = requests[indexPath.row]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimesheetLoadingCell.reuseIdentifier, for: indexPath)
            return cell
        }
    }
}

extension TimesheetSharingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
