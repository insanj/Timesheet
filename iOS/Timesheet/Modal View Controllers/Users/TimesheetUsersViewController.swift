//
//  TimesheetUsersViewController.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/15/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit
import BulletinBoard

@objcMembers
class TimesheetUsersViewController: UIViewController {
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var availableUsers: [TimesheetUser]?
    
    let cancelButton = TimesheetButton(timesheetColor(name: "Blue"))

    init() {
        super.init(nibName: nil, bundle: nil)
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
        cancelButton.setTitle("    Done    ", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(cancelButton)
        
        cancelButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -5.0).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -15).isActive = true
        
        // setup collection view
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.register(TimesheetUserCell.self, forCellWithReuseIdentifier: TimesheetUserCell.reuseIdentifier)
        collectionView.register(TimesheetLoadingCell.self, forCellWithReuseIdentifier: TimesheetLoadingCell.reuseIdentifier)

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 10.0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshFromBackend()
    }

    func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    // networking
    let friendManager = TimesheetFriendManager()
}

extension TimesheetUsersViewController {
    func refreshFromBackend() {
        friendManager.getAvailableUsers({ (users, error) in
            if let validError = error {
                showError(validError, from: self)
                self.availableUsers = [TimesheetUser]()
            } else if users == nil {
                self.availableUsers = [TimesheetUser]()
            } else {
                self.availableUsers = users
            }
            
            OperationQueue.main.addOperation {
                self.collectionView.reloadData()
            }
        })?.resume()
    }
}

extension TimesheetUsersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = min(view.frame.size.width, collectionView.frame.size.width - 10.0)
        return CGSize(width: width, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
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

extension TimesheetUsersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableUsers == nil ? 1 : availableUsers!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let validUsers = availableUsers {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimesheetUserCell.reuseIdentifier, for: indexPath) as? TimesheetUserCell else {
                fatalError()
            }
            
            cell.user = validUsers[indexPath.row]
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimesheetLoadingCell.reuseIdentifier, for: indexPath) as? TimesheetLoadingCell else {
                fatalError()
            }
            
            cell.detailLabel.text = "Loading available users..."
            cell.indicatorView.startAnimating()
            
            return cell
        }
    }
}

extension TimesheetUsersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let validUsers = availableUsers else {
            return
        }

        let user = validUsers[indexPath.row]
        
        let bulletin = BulletinManager(rootItem: PageBulletinItem(title: ""))
        bulletin.prepare()
        bulletin.presentBulletin(above: self)
        bulletin.displayActivityIndicator()
        
        _ = friendManager.ceateFriendRequest(friend: user) { (request, error) in
            OperationQueue.main.addOperation {
                bulletin.dismissBulletin()
            }
            
            if let validError = error {
                showError(validError, from: self)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

