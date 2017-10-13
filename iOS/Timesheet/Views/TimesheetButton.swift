//
//  TimesheetButton.swift
//  Timesheet
//
//  Created by Julian Weiss on 10/9/17.
//  Copyright © 2017 Julian Weiss. All rights reserved.
//

import UIKit

@objcMembers
class TimesheetButton: UIButton {
    let color: TimesheetColor
    
    init(_ color: TimesheetColor) {
        self.color = color
        super.init(frame: CGRect.zero)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        backgroundColor = color.backgroundColor
        setTitleColor(color.foregroundColor, for: .normal)
        layer.masksToBounds = true
        layer.cornerRadius = 8.0
        layer.borderWidth = 2.0
        layer.borderColor = color.backgroundColor.cgColor
        
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func touchDown() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.backgroundColor = self.color.backgroundColor.withAlphaComponent(0.5)
        }, completion: nil)
    }
    
    func touchUp() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.backgroundColor = self.color.backgroundColor
        }, completion: nil)
    }
}
