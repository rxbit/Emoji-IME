//
//  CatelogScrollView.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/3/2.
//  Copyright (c) 2015年 wua. All rights reserved.
//

import UIKit

class CategoryScrollView: UIScrollView {
    private var activiteButton: UIButton?
    private var buttons: [UIButton]!
    private var activeFlag: UIView!
    private var activeFlagCenterYConstraint: NSLayoutConstraint!
    
    let tabStrings: [String] = ["开心","愤怒","愉快","搞怪","简单","短语","呵呵","哈哈"]
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        didInitView()
    }
    
    override init() {
       super.init()
    }

    private func didInitView() {
        backgroundColor = UIColor.greenColor()
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 36)
        self.addConstraints([heightConstraint])
        
        activeFlag = UIView()
        activeFlag.setTranslatesAutoresizingMaskIntoConstraints(false)
        activeFlag.backgroundColor = UIColor.purpleColor()
        activeFlag.layer.cornerRadius = 2.5
        addSubview(activeFlag)
        
        let w = NSLayoutConstraint(item: activeFlag, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 5)
        let h = NSLayoutConstraint(item: activeFlag, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 5)
        let t = NSLayoutConstraint(item: activeFlag, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        addConstraints([w,h,t])
        
        buttons = []
        for tabString in tabStrings {
            var button = UIButton.buttonWithType(.System) as UIButton
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            button.setTitle(tabString, forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.addTarget(self, action: "SELdidTapCategoryTabButton:", forControlEvents: .TouchUpInside)
            buttons.append(button)
            addSubview(button)
        }
        
        for (index,button) in enumerate(buttons) {
            var l: NSLayoutConstraint!
            if index == 0 {
                l = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 2)
                activiteButton = button
            }
            else {
                l = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: buttons[index-1], attribute: .Right, multiplier: 1, constant: 2)
            }
            let x = NSLayoutConstraint(item: button, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
            let w = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 48)
            addConstraints([l,x,w])
        }
        setActiveTabwithButton(activiteButton)
    }
    
    func setActiveTabwithButton(button: UIButton?) {
        if button == nil {
            activeFlag.hidden = true
        } else {
            activeFlag.hidden = false
            activiteButton = button
            if activeFlagCenterYConstraint != nil {
                removeConstraint(activeFlagCenterYConstraint)
            }
            activeFlagCenterYConstraint = NSLayoutConstraint(item: activeFlag, attribute: .CenterX, relatedBy: .Equal, toItem: activiteButton,attribute: .CenterX, multiplier: 1, constant: 0)
            addConstraints([activeFlagCenterYConstraint])
        }
    }
    
    func SELdidTapCategoryTabButton(sender: AnyObject?) {
        let senderButton = sender as UIButton
        setActiveTabwithButton(senderButton)
    }
}
