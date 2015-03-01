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
    var currentKeyboardType = KeyboardType.Handwrite
    var nextKeyboardButton: UIButton!
    var backSpaceButton: UIButton!
    var spaceButton: UIButton!
    var doneButton: UIButton!
    var inputTypeButton: UIButton!
    var recoView: UIView!
    var handwriteView: CanvesView!
    var emojiView: UIView!
    var currentMainView: UIView!
    var candidateScrollView: CandidateScrollerView!
    var candidateScrollViewHeightConstraint: NSLayoutConstraint!

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        layoutViews()
        layoutMainView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputView.backgroundColor = UIColor(red: 234/255.0, green: 176/255.0, blue: 227/255.0, alpha: 1)
        
        self.candidateScrollView = CandidateScrollerView()
        self.candidateScrollView.inputDelegate = self
    
        self.recoView = UIView()
        self.recoView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.inputTypeButton = EKB_Button.buttonWithType(.System) as UIButton
        self.inputTypeButton.setTitle("✏", forState: .Normal)
        inputTypeButton.addTarget(self, action: "doInputType", forControlEvents: .TouchUpInside)
        
        self.nextKeyboardButton = EKB_Button.buttonWithType(.System) as UIButton
        self.nextKeyboardButton.setTitle(NSLocalizedString("🌐", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.spaceButton = EKB_Button.buttonWithType(.System) as UIButton
        self.spaceButton.setTitle("Space", forState: .Normal)
        self.spaceButton.addTarget(self, action: "doSpace", forControlEvents: .TouchUpInside)
        self.spaceButton.backgroundColor = UIColor.whiteColor()
        
        self.backSpaceButton = EKB_Button.buttonWithType(.System) as UIButton
        self.backSpaceButton.setTitle("🔙", forState: .Normal)
        self.backSpaceButton.addTarget(self, action: "doBackSpace", forControlEvents: .TouchUpInside)
        
        self.doneButton = EKB_Button.buttonWithType(.System) as UIButton
        self.doneButton.setTitle("Done", forState: .Normal)
        self.doneButton.addTarget(self, action: "doReturn", forControlEvents: .TouchUpInside)

        self.inputView.addSubview(self.candidateScrollView)
        self.inputView.addSubview(self.recoView)
        self.inputView.addSubview(self.inputTypeButton)
        self.inputView.addSubview(self.nextKeyboardButton)
        self.inputView.addSubview(self.spaceButton)
        self.inputView.addSubview(self.backSpaceButton)
        self.inputView.addSubview(self.doneButton)
        
        self.handwriteView = CanvesView()
        self.handwriteView.delegate = self.candidateScrollView
        
        emojiView = UIView()
        emojiView.setTranslatesAutoresizingMaskIntoConstraints(false)
        emojiView.backgroundColor = UIColor.purpleColor()
        
        recoView.addSubview(handwriteView)
        currentMainView = handwriteView
    }
    
    func layoutMainView() {
        let t = NSLayoutConstraint(item: currentMainView, attribute: .Top, relatedBy: .Equal, toItem: recoView, attribute: .Top, multiplier: 1, constant: 0)
        let l = NSLayoutConstraint(item: currentMainView, attribute: .Left, relatedBy: .Equal, toItem: recoView, attribute: .Left, multiplier: 1, constant: 0)
        let r = NSLayoutConstraint(item: currentMainView, attribute: .Right, relatedBy: .Equal, toItem: recoView, attribute: .Right, multiplier: 1, constant: 0)
        let b = NSLayoutConstraint(item: currentMainView, attribute: .Bottom, relatedBy: .Equal, toItem: recoView, attribute: .Bottom, multiplier: 1, constant: 0)
        self.recoView.addConstraints([t,l,r,b])
    }
    
    func layoutViews() {
        let candidateScrollViewTopConstraint = NSLayoutConstraint(item: self.candidateScrollView, attribute: .Top, relatedBy: .Equal, toItem: self.inputView, attribute: .Top, multiplier: 1, constant: 2)
        let candidateScrollViewRightConstraint = NSLayoutConstraint(item: self.candidateScrollView, attribute: .Right, relatedBy: .Equal, toItem: self.inputView, attribute: .Right, multiplier: 1, constant: 0)
        let candidateScrollViewLeftConstraint = NSLayoutConstraint(item: self.candidateScrollView, attribute: .Left, relatedBy: .Equal, toItem: self.inputView, attribute: .Left, multiplier: 1, constant: 0)
        self.inputView.addConstraints([
            candidateScrollViewTopConstraint,
            candidateScrollViewLeftConstraint,
            candidateScrollViewRightConstraint,
        ])
        
        let recoViewHeightConstraint = NSLayoutConstraint(item: self.recoView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 160)
        recoViewHeightConstraint.priority = 999;
        var recoViewTopConstraint = NSLayoutConstraint(item: self.recoView, attribute: .Top, relatedBy: .Equal, toItem: self.candidateScrollView, attribute: .Bottom, multiplier: 1, constant: 6)
        var recoViewLeftConstraint = NSLayoutConstraint(item: self.recoView, attribute: .Left, relatedBy: .Equal, toItem: self.inputView, attribute: .Left, multiplier: 1, constant: 4)
        var recoViewRightConstraint = NSLayoutConstraint(item: self.recoView, attribute: .Right, relatedBy: .Equal, toItem: self.inputView, attribute: .Right, multiplier: 1, constant: -4)
        var recoViewBottomConstraint = NSLayoutConstraint(item: self.recoView, attribute: .Bottom, relatedBy: .Equal, toItem: self.inputTypeButton, attribute: .Top, multiplier: 1, constant: -8)
        self.inputView.addConstraints([
            recoViewHeightConstraint,
            recoViewTopConstraint,
            recoViewLeftConstraint,
            recoViewRightConstraint,
            recoViewBottomConstraint,
        ])
        
        var inputTypeButtonLeftSideConstraint = NSLayoutConstraint(item: self.inputTypeButton, attribute: .Left, relatedBy: .Equal, toItem: self.inputView, attribute: .Left, multiplier: 1, constant: 4)
        var inputTypeButtonBottomConstraint = NSLayoutConstraint(item: self.inputTypeButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.inputView, attribute: .Bottom, multiplier: 1, constant: -4)
        var inputTypeButtonHeightConstraint = NSLayoutConstraint(item: self.inputTypeButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40)
        var inputTypeButtonWidthConstraint = NSLayoutConstraint(item: self.inputTypeButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50)
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
        self.inputView.addConstraints([
            spaceButtonTopSideConstraint,
            spaceButtonLeftSideConstraint,
            spaceButtonHeightConstraint
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
        
    }
    
    func doInputType() {
        switch currentKeyboardType {
        case .Handwrite:
            currentKeyboardType = .Emoji
            recoView.addSubview(emojiView)
            currentMainView = emojiView
            handwriteView.removeFromSuperview()
            inputTypeButton.setTitle("^_^", forState: .Normal)
        case .Emoji:
            currentKeyboardType = .Handwrite
            recoView.addSubview(handwriteView)
            currentMainView = handwriteView
            emojiView.removeFromSuperview()
            inputTypeButton.setTitle("✏", forState: .Normal)
        }
        layoutMainView()
    }
    
    func doBackSpace() {
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        switch currentKeyboardType {
        case .Handwrite:
            if self.handwriteView.deleteLatestPath() == false {
                proxy.deleteBackward()
            }
        case .Emoji:
            proxy.deleteBackward()
        }
    }
    
    func doSpace() {
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        proxy.insertText(" ")
    }
    
    func doReturn() {
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

extension KeyboardViewController: CandidateScrollerViewDelegate {
    func didRecivedInputString(string: String) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(string)
        handwriteView.clearView()
    }
}
