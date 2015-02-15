//
//  KeyboardViewController.swift
//  EmojiKeyBoard
//
//  Created by Wuhua Dai on 14/12/23.
//  Copyright (c) 2014年 wua. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    var nextKeyboardButton: UIButton!
    var recoView: CanvesView!
    var candidateScrollView: CandidateScrollerView!
    var candidateScrollViewHeightConstraint: NSLayoutConstraint!

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        layoutViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.recoView = CanvesView()
        self.recoView.backgroundColor = UIColor.blackColor()
        self.recoView.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.nextKeyboardButton = UIButton.buttonWithType(.System) as UIButton
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.candidateScrollView = CandidateScrollerView()
        self.recoView.delegate = self.candidateScrollView
        self.candidateScrollView.inputDelegate = self
        self.candidateScrollView.backgroundColor = UIColor.purpleColor()
        self.candidateScrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.inputView.addSubview(self.candidateScrollView)
        self.inputView.addSubview(self.recoView)
        self.inputView.addSubview(self.nextKeyboardButton)
        
    }
    
    func layoutViews() {
        let candidateScrollViewTopConstraint = NSLayoutConstraint(item: self.candidateScrollView, attribute: .Top, relatedBy: .Equal, toItem: self.inputView, attribute: .Top, multiplier: 1, constant: 0)
        let candidateScrollViewRightConstraint = NSLayoutConstraint(item: self.candidateScrollView, attribute: .Right, relatedBy: .Equal, toItem: self.inputView, attribute: .Right, multiplier: 1.0, constant: 0.0)
        let candidateScrollViewLeftConstraint = NSLayoutConstraint(item: self.candidateScrollView, attribute: .Left, relatedBy: .Equal, toItem: self.inputView, attribute: .Left, multiplier: 1.0, constant: 0.0)
        self.inputView.addConstraints([candidateScrollViewTopConstraint,candidateScrollViewLeftConstraint,candidateScrollViewRightConstraint])
        
        let recoViewHeightConstraint = NSLayoutConstraint(item: self.recoView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200.0)
        recoViewHeightConstraint.priority = 999;
        var recoViewTopConstraint = NSLayoutConstraint(item: self.recoView, attribute: .Top, relatedBy: .Equal, toItem: self.candidateScrollView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        var recoViewLeftConstraint = NSLayoutConstraint(item: self.recoView, attribute: .Left, relatedBy: .Equal, toItem: self.inputView, attribute: .Left, multiplier: 1.0, constant: 0.0)
        var recoViewRightConstraint = NSLayoutConstraint(item: self.recoView, attribute: .Right, relatedBy: .Equal, toItem: self.inputView, attribute: .Right, multiplier: 1.0, constant: 0.0)
        var recoViewBottomConstraint = NSLayoutConstraint(item: self.recoView, attribute: .Bottom, relatedBy: .Equal, toItem: self.nextKeyboardButton, attribute: .Top, multiplier: 1.0, constant: 0.0)
        self.inputView.addConstraints([recoViewHeightConstraint,recoViewTopConstraint,recoViewLeftConstraint,recoViewRightConstraint,recoViewBottomConstraint])
        
        var nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.inputView, attribute: .Left, multiplier: 1.0, constant: 0.0)
        var nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.inputView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        var nextKeyboardButtonHeightConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 32.0)
        self.inputView.addConstraints([nextKeyboardButtonLeftSideConstraint,
            nextKeyboardButtonBottomConstraint,nextKeyboardButtonHeightConstraint
            ])
        
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
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }
    
}

extension KeyboardViewController: CandidateScrollerViewDelegate {
    func didRecivedInputString(string: String) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(string)
    }
}
