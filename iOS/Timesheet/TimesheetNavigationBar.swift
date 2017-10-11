//
//  TimesheetNavigationBar.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/7/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

@objcMembers
class TimesheetNavigationBar: UIView {
    let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light)))
    
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let handleView = TimesheetHandleView()
    let rightButton = UIButton()
    
    let handleHeight: CGFloat = 8.0
    let navigationBarHeight: CGFloat = 70.0 // 62.0 + 8.0 (handleHeight)
    
    var heightConstraint: NSLayoutConstraint?
    var titleBottomConstraint: NSLayoutConstraint?
    
    var panGestureRecognizer: UIPanGestureRecognizer?
    let pulldownView = TimesheetPulldownView()
    var pulldownHeight: CGFloat
    
    var showingHandle = true {
        willSet {
            if newValue != showingHandle {
                updateHandle(newValue)
            }
        }
    }

    var enabled: Bool = false // pulldown enabled
    
    init(_ pulldownHeight: CGFloat) { // default value should hopefully never be used
        self.pulldownHeight = pulldownHeight
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.clear
        
        heightConstraint = heightAnchor.constraint(equalToConstant: navigationBarHeight)
        heightConstraint?.isActive = true
        
        // setup background view
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 12.0
        backgroundView.layer.borderWidth = 1.0
        backgroundView.layer.borderColor = UIColor(white: 0.0, alpha: 0.1).cgColor
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: -10.0).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: -1.0).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: 1.0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.contentView.addSubview(vibrancyView)
        
        vibrancyView.leftAnchor.constraint(equalTo: backgroundView.contentView.leftAnchor).isActive = true
        vibrancyView.rightAnchor.constraint(equalTo: backgroundView.contentView.rightAnchor).isActive = true
        vibrancyView.topAnchor.constraint(equalTo: backgroundView.contentView.topAnchor).isActive = true
        vibrancyView.bottomAnchor.constraint(equalTo: backgroundView.contentView.bottomAnchor).isActive = true

        // setup title label
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        titleBottomConstraint = titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0)
        titleBottomConstraint?.isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
        
        // setup detail label
        detailLabel.textColor = UIColor(white:0.0, alpha: 0.6)
        detailLabel.textAlignment = .center
        detailLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        detailLabel.numberOfLines = 1
        detailLabel.setContentHuggingPriority(.required, for: .vertical)
        detailLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(detailLabel)
        
        detailLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
        
        // setup right button
        rightButton.setTitle("Share", for: .normal)
        rightButton.setTitleColor(UIColor.black, for: .normal)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightButton)
        
        rightButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
        rightButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true

        // setup handle view
        handleView.backgroundColor = handleView.tintColor
        handleView.layer.masksToBounds = true
        handleView.layer.cornerRadius = 1.5
        handleView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.contentView.addSubview(handleView)
        
        handleView.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
        handleView.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        handleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        handleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0).isActive = true
        
        // setup gesture recognizer
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
        addGestureRecognizer(panGestureRecognizer!)
        
        // setup pulldown view
        pulldownView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pulldownView)
        
        pulldownView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        pulldownView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        pulldownView.heightAnchor.constraint(equalToConstant: pulldownHeight).isActive = true
        pulldownView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -navigationBarHeight).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func updateHandle(_ showing: Bool) {
        self.layoutIfNeeded()
        
        if showing {
            heightConstraint?.constant = navigationBarHeight
            titleBottomConstraint?.constant = -10.0
        } else {
            heightConstraint?.constant = navigationBarHeight - (handleHeight + 10.0)
            titleBottomConstraint?.constant = -5.0
        }
        
        let alpha: CGFloat = showing ? 1.0 : 0.0
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            self.handleView.alpha = alpha
            self.superview?.layoutIfNeeded()
        }, completion: nil)
    }
    
    var showingPulldown = false
    var panGestureRecognizedInitialLocation: CGPoint?
    func panGestureRecognized(_ gestureRecognizer: UIPanGestureRecognizer) {
        if !enabled {
            return
        }
        
        let location = gestureRecognizer.location(in: gestureRecognizer.view!)
        let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view!).y
        
        let initialLocation = panGestureRecognizedInitialLocation ?? location
        let offset = location.y - initialLocation.y
        let revealedHeight = showingPulldown ? offset + pulldownHeight : offset
                
        switch gestureRecognizer.state { // .recognized is catch-all
        case .began:
            panGestureRecognizedInitialLocation = location
            updatePullDown(0, true, velocity)
        case .possible, .changed:
            updatePullDown(offset, false, velocity)
        case .ended, .cancelled, .failed:
            if revealedHeight >= pulldownHeight {
                showPulldown(true, velocity)
            } else {
                showingPulldown = false
                updatePullDown(0, true, velocity)
            }
        }
    }
    
    func updatePullDown(_ offset: CGFloat, _ animated: Bool, _ velocity: CGFloat) {
        var baseOffset: CGFloat

        if showingPulldown {
            baseOffset = pulldownHeight + navigationBarHeight
        } else {
            baseOffset = showingHandle ? navigationBarHeight : navigationBarHeight - (handleHeight + 10.0)
        }
        
        heightConstraint?.constant = baseOffset + offset
        
        let reasonableVelocity = min(abs(velocity), 8.0)
        
        if animated {
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: reasonableVelocity, options: [], animations: {
                self.superview?.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.superview?.layoutIfNeeded()
        }
    }
    
    func showPulldown(_ animated: Bool, _ velocity: CGFloat) {
        showingPulldown = true
        heightConstraint?.constant = pulldownHeight + navigationBarHeight
        
        let reasonableVelocity = min(abs(velocity), 8.0)
        
        if animated {
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: reasonableVelocity, options: [], animations: {
                self.superview?.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.superview?.layoutIfNeeded()
        }
    }
    
    func hidePulldown(_ animated: Bool, _ velocity: CGFloat) {
        showingPulldown = false
        heightConstraint?.constant = showingHandle ? navigationBarHeight : navigationBarHeight - (handleHeight + 10.0)
        
        let reasonableVelocity = min(abs(velocity), 8.0)
        
        if animated {
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: reasonableVelocity, options: [], animations: {
                self.superview?.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.superview?.layoutIfNeeded()
        }
    }
}

class TimesheetHandleView: UIView {
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        backgroundColor = tintColor
    }
}
