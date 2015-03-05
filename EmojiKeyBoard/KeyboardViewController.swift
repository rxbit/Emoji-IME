//
//  KeyboardViewController.swift
//  EmojiKeyBoard
//
//  Created by Wuhua Dai on 14/12/23.
//  Copyright (c) 2014年 wua. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    enum KeyboardType: Int {
        case Emoji = 1, Handwrite
    }
    private var initOnceFlag = true
    private var currentKeyboardType = KeyboardType.Emoji
    private var nextKeyboardButton: UIButton!
    private var backSpaceButton: UIButton!
    private var spaceButton: UIButton!
    private var doneButton: UIButton!
    private var inputTypeButton: UIButton!
    private var recoView: UIView!
    private var emojiKeyboardViewController: EmojiKeyboardViewController!
    private var handwriteViewController: HandwriteViewController!

    override func updateViewConstraints() {
        super.updateViewConstraints()
        layoutViews()
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputView.backgroundColor = UIColor(red: 234/255.0, green: 176/255.0, blue: 227/255.0, alpha: 1)
        
        self.recoView = UIView()
        self.recoView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.inputTypeButton = MyKeyboardButton.buttonWithType(.System) as UIButton
        self.inputTypeButton.setTitle("✏", forState: .Normal)
        inputTypeButton.addTarget(self, action: "SELdoInputType", forControlEvents: .TouchUpInside)
        
        self.nextKeyboardButton = MyKeyboardButton.buttonWithType(.System) as UIButton
        self.nextKeyboardButton.setTitle(NSLocalizedString("🌐", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.spaceButton = MyKeyboardButton.buttonWithType(.System) as UIButton
        self.spaceButton.setTitle("Space", forState: .Normal)
        self.spaceButton.addTarget(self, action: "SELdoSpace", forControlEvents: .TouchUpInside)
        self.spaceButton.backgroundColor = UIColor.whiteColor()
        
        self.backSpaceButton = MyKeyboardButton.buttonWithType(.System) as UIButton
        self.backSpaceButton.setTitle("🔙", forState: .Normal)
        self.backSpaceButton.addTarget(self, action: "SELdoBackSpace", forControlEvents: .TouchUpInside)
        
        self.doneButton = MyKeyboardButton.buttonWithType(.System) as UIButton
        self.doneButton.setTitle("Done", forState: .Normal)
        self.doneButton.addTarget(self, action: "SELdoReturn", forControlEvents: .TouchUpInside)

        self.inputView.addSubview(self.recoView)
        self.inputView.addSubview(self.inputTypeButton)
        self.inputView.addSubview(self.nextKeyboardButton)
        self.inputView.addSubview(self.spaceButton)
        self.inputView.addSubview(self.backSpaceButton)
        self.inputView.addSubview(self.doneButton)
        
        handwriteViewController = HandwriteViewController()
        handwriteViewController.inputDelegate = self
        self.addChildViewController(handwriteViewController)
        
        emojiKeyboardViewController = EmojiKeyboardViewController()
        emojiKeyboardViewController.inputDelegate = self
        self.addChildViewController(emojiKeyboardViewController)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsUpdateConstraints()
        if initOnceFlag == true {
            initOnceFlag = false
            SELdoInputType()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func layoutViews() {
        var recoViewTopConstraint = NSLayoutConstraint(item: self.recoView, attribute: .Top, relatedBy: .Equal, toItem: self.inputView, attribute: .Top, multiplier: 1, constant: 0)
        var recoViewLeftConstraint = NSLayoutConstraint(item: self.recoView, attribute: .Left, relatedBy: .Equal, toItem: self.inputView, attribute: .Left, multiplier: 1, constant: 2)
        var recoViewRightConstraint = NSLayoutConstraint(item: self.recoView, attribute: .Right, relatedBy: .Equal, toItem: self.inputView, attribute: .Right, multiplier: 1, constant: -2)
        var recoViewBottomConstraint = NSLayoutConstraint(item: self.recoView, attribute: .Bottom, relatedBy: .Equal, toItem: self.inputTypeButton, attribute: .Top, multiplier: 1, constant: -4)
        self.inputView.addConstraints([
            recoViewTopConstraint,
            recoViewLeftConstraint,
            recoViewRightConstraint,
            recoViewBottomConstraint,
        ])
        
        var inputTypeButtonLeftSideConstraint = NSLayoutConstraint(item: self.inputTypeButton, attribute: .Left, relatedBy: .Equal, toItem: self.inputView, attribute: .Left, multiplier: 1, constant: 4)
        var inputTypeButtonBottomConstraint = NSLayoutConstraint(item: self.inputTypeButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.inputView, attribute: .Bottom, multiplier: 1, constant: -4)
        var inputTypeButtonHeightConstraint = NSLayoutConstraint(item: self.inputTypeButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40)
        var inputTypeButtonWidthConstraint = NSLayoutConstraint(item: self.inputTypeButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50)
        inputTypeButtonWidthConstraint.priority = 999
        self.inputView.addConstraints([
            inputTypeButtonLeftSideConstraint,
            inputTypeButtonBottomConstraint,
            inputTypeButtonHeightConstraint,
            inputTypeButtonWidthConstraint,
        ])
        
        var nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.inputTypeButton, attribute: .Right, multiplier: 1, constant: 4)
        var nextKeyboardButtonTopConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Top, relatedBy: .Equal, toItem: self.inputTypeButton, attribute: .Top, multiplier: 1, constant: 0)
        var nextKeyboardButtonWidthConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Width, relatedBy: .Equal, toItem: self.inputTypeButton, attribute: .Width, multiplier: 1, constant: 0)
        var nextKeyboardButtonHeightConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Height, relatedBy: .Equal, toItem: self.inputTypeButton, attribute: .Height, multiplier: 1, constant: 0)
        self.inputView.addConstraints([
            nextKeyboardButtonTopConstraint,
            nextKeyboardButtonWidthConstraint,
            nextKeyboardButtonHeightConstraint,
            nextKeyboardButtonLeftSideConstraint,
        ])
        
        var spaceButtonLeftSideConstraint = NSLayoutConstraint(item: self.spaceButton, attribute: .Left, relatedBy: .Equal, toItem: self.nextKeyboardButton, attribute: .Right, multiplier: 1, constant: 4)
        var spaceButtonTopSideConstraint = NSLayoutConstraint(item: self.spaceButton, attribute: .Top, relatedBy: .Equal, toItem: self.inputTypeButton, attribute: .Top, multiplier: 1, constant: 0)
        var spaceButtonHeightConstraint = NSLayoutConstraint(item: self.spaceButton, attribute: .Height, relatedBy: .Equal, toItem: self.inputTypeButton, attribute: .Height, multiplier: 1, constant: 0)
        let spaceButtonWidthConstraint = NSLayoutConstraint(item: spaceButton, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 10)
        self.inputView.addConstraints([
            spaceButtonTopSideConstraint,
            spaceButtonLeftSideConstraint,
            spaceButtonHeightConstraint,
            spaceButtonWidthConstraint
        ])
        
        var backSpaceButtonLeftSideConstraint = NSLayoutConstraint(item: self.backSpaceButton, attribute: .Left, relatedBy: .Equal, toItem: self.spaceButton, attribute: .Right, multiplier: 1, constant: 4)
        var backSpaceButtonTopConstraint = NSLayoutConstraint(item: self.backSpaceButton, attribute: .Top, relatedBy: .Equal, toItem: self.inputTypeButton, attribute: .Top, multiplier: 1, constant: 0)
        var backSpaceButtonWidthConstraint = NSLayoutConstraint(item: self.backSpaceButton, attribute: .Width, relatedBy: .Equal, toItem: self.inputTypeButton, attribute: .Width, multiplier: 1, constant: 0)
        var backSpaceButtonHeightConstraint = NSLayoutConstraint(item: self.backSpaceButton, attribute: .Height, relatedBy: .Equal, toItem: self.inputTypeButton, attribute: .Height, multiplier: 1, constant: 0)
        self.inputView.addConstraints([
            backSpaceButtonTopConstraint,
            backSpaceButtonWidthConstraint,
            backSpaceButtonHeightConstraint,
            backSpaceButtonLeftSideConstraint,
        ])
        
        var doneButtonLeftSideConstraint = NSLayoutConstraint(item: self.doneButton, attribute: .Left, relatedBy: .Equal, toItem: self.backSpaceButton, attribute: .Right, multiplier: 1, constant: 4)
        var doneButtonTopConstraint = NSLayoutConstraint(item: self.doneButton, attribute: .Top, relatedBy: .Equal, toItem: self.inputTypeButton, attribute: .Top, multiplier: 1, constant: 0)
        var doneButtonWidthConstraint = NSLayoutConstraint(item: self.doneButton, attribute: .Width, relatedBy: .Equal, toItem: self.inputTypeButton, attribute: .Width, multiplier: 1, constant: 0)
        var doneButtonHeightConstraint = NSLayoutConstraint(item: self.doneButton, attribute: .Height, relatedBy: .Equal, toItem: self.inputTypeButton, attribute: .Height, multiplier: 1, constant: 0)
        var doneButtonRightSideConstraint = NSLayoutConstraint(item: self.doneButton, attribute: .Right, relatedBy: .Equal, toItem: self.inputView, attribute: .Right, multiplier: 1, constant: -4)
        self.inputView.addConstraints([
            doneButtonTopConstraint,
            doneButtonWidthConstraint,
            doneButtonHeightConstraint,
            doneButtonLeftSideConstraint,
            doneButtonRightSideConstraint,
        ])
    }
    
    private func layoutFillSuperView(view: UIView) {
        let t = NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: view.superview, attribute: .Top, multiplier: 1, constant: 0)
        let l = NSLayoutConstraint(item: view, attribute: .Left, relatedBy: .Equal, toItem: view.superview, attribute: .Left, multiplier: 1, constant: 0)
        let r = NSLayoutConstraint(item: view, attribute: .Right, relatedBy: .Equal, toItem: view.superview, attribute: .Right, multiplier: 1, constant: 0)
        let b = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: view.superview, attribute: .Bottom, multiplier: 1, constant: 0)
        view.superview!.addConstraints([t,l,r,b])
    }
    
    func SELdoInputType() {
        switch currentKeyboardType {
        case .Handwrite:
            currentKeyboardType = .Emoji
            handwriteViewController.didMoveToParentViewController(nil)
            handwriteViewController.view.removeFromSuperview()
            inputTypeButton.setTitle("^_^", forState: .Normal)
            self.recoView.addSubview(emojiKeyboardViewController.view)
            emojiKeyboardViewController.didMoveToParentViewController(self)
            layoutFillSuperView(emojiKeyboardViewController.view)
        case .Emoji:
            currentKeyboardType = .Handwrite
            emojiKeyboardViewController.didMoveToParentViewController(nil)
            emojiKeyboardViewController.view.removeFromSuperview()
            inputTypeButton.setTitle("✏", forState: .Normal)
            recoView.addSubview(handwriteViewController.view)
            handwriteViewController.didMoveToParentViewController(self)
            layoutFillSuperView(handwriteViewController.view)
        }
    }
    
    func SELdoBackSpace() {
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        switch currentKeyboardType {
        case .Handwrite:
            if self.handwriteViewController.deleteLatestPath() == false {
                proxy.deleteBackward()
            }
        case .Emoji:
            proxy.deleteBackward()
        }
    }
    
    func SELdoSpace() {
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        proxy.insertText(" ")
    }
    
    func SELdoReturn() {
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        proxy.insertText("\n")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        var proxy = self.textDocumentProxy as UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        self.inputTypeButton.setTitleColor(textColor, forState: .Normal)
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
        self.spaceButton.setTitleColor(textColor, forState: .Normal)
        self.backSpaceButton.setTitleColor(textColor, forState: .Normal)
        self.doneButton.setTitleColor(textColor, forState: .Normal)
        var doneText: String
        switch proxy.returnKeyType! {
        case UIReturnKeyType.Default:
            doneText = "Return"
        case UIReturnKeyType.Done:
            doneText = "Done"
        case UIReturnKeyType.Go:
            doneText = "Go"
        case UIReturnKeyType.Send:
            doneText = "Send"
        case UIReturnKeyType.Search:
            doneText = "Search"
        case UIReturnKeyType.Next:
            doneText = "Next"
        default:
            doneText = "Return"
        }
        self.doneButton.setTitle(doneText, forState: .Normal)
    }
    
}

extension KeyboardViewController: CandidateScrollViewDelegate {
    func didRecivedInputString(string: String) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(string)
    }
}