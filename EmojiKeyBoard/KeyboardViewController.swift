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
        self.inputView.backgroundColor = KeyboardThemeManager.theme.KeyboardBackgroundColor
        
        self.recoView = UIView()
        
        self.inputTypeButton = MyKeyboardButton.buttonWithType(.System) as UIButton
        self.inputTypeButton.setTitle("✏", forState: .Normal)
        inputTypeButton.addTarget(self, action: "SELdoInputType", forControlEvents: .TouchUpInside)
        
        self.nextKeyboardButton = MyKeyboardButton.buttonWithType(.System) as UIButton
        self.nextKeyboardButton.setTitle(NSLocalizedString("🌐", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.spaceButton = MyKeyboardButton.buttonWithType(.System) as UIButton
        self.spaceButton.setTitle("Space", forState: .Normal)
        self.spaceButton.addTarget(self, action: "SELdoSpace", forControlEvents: .TouchUpInside)
        self.spaceButton.backgroundColor = KeyboardThemeManager.theme.KeyboardSpaceButtonColorNormal
        
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
        recoView.snp_makeConstraints { make in
            make.top.equalTo(self.inputView)
            make.left.equalTo(self.inputView).with.offset(2)
            make.right.equalTo(self.inputView).with.offset(-2)
            make.bottom.equalTo(self.inputTypeButton.snp_top).with.offset(-4)
            make.size.greaterThanOrEqualTo(CGSizeMake(100, 100))
        }
        
        inputTypeButton.snp_makeConstraints { make in
            make.left.equalTo(self.inputView).with.offset(4)
            make.bottom.equalTo(self.inputView).with.offset(-4)
            make.height.equalTo(40)
            make.width.equalTo(50).priority(999)
        }

        nextKeyboardButton.snp_makeConstraints { make in
            make.size.equalTo(self.inputTypeButton)
            make.left.equalTo(self.inputTypeButton.snp_right).with.offset(4)
            make.centerY.equalTo(self.inputTypeButton)
        }
        
        spaceButton.snp_makeConstraints { make in
            make.height.equalTo(self.inputTypeButton)
            make.left.equalTo(self.nextKeyboardButton.snp_right).with.offset(4)
            make.centerY.equalTo(self.inputTypeButton)
            make.width.greaterThanOrEqualTo(10)
        }
        
        backSpaceButton.snp_makeConstraints { make in
            make.size.equalTo(self.inputTypeButton)
            make.left.equalTo(self.spaceButton.snp_right).with.offset(4)
            make.centerY.equalTo(self.inputTypeButton)
        }
        
        doneButton.snp_makeConstraints { make in
            make.size.equalTo(self.inputTypeButton)
            make.left.equalTo(self.backSpaceButton.snp_right).with.offset(4)
            make.centerY.equalTo(self.inputTypeButton)
            make.right.equalTo(self.inputView).with.offset(-4)
        }
    }
    
    private func layoutFillSuperView(view: UIView) {
        view.snp_makeConstraints { make in
            make.edges.equalTo(view.superview!)
            return
        }
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
            textColor = KeyboardThemeManager.theme.KeyboardButtonTextColorLight
        } else {
            textColor = KeyboardThemeManager.theme.KeyboardButtonTextColorDark
        }
        self.inputTypeButton.setTitleColor(textColor, forState: .Normal)
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
        self.spaceButton.setTitleColor(textColor, forState: .Normal)
        self.backSpaceButton.setTitleColor(textColor, forState: .Normal)
        self.doneButton.setTitleColor(textColor, forState: .Normal)
        self.doneButton.setTitle(proxy.returnKeyType!.description, forState: .Normal)
    }
    
}

extension KeyboardViewController: CandidateScrollViewDelegate {
    func didRecivedInputString(string: String) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(string)
    }
}