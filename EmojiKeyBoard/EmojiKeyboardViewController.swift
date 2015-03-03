//
//  EmojiKeyboardViewController.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/3/3.
//  Copyright (c) 2015年 wua. All rights reserved.
//

import UIKit
import AudioToolbox

class EmojiKeyboardViewController: UIViewController {
    private var buttons: [UIButton]!
    private var buttonWidthConstraint, buttonHeightConstraint: NSLayoutConstraint?
    private var emojiStrings = ["(^_^)","(-v-)","(QAQ)","(QAO)"]
    private var categoryScrollView: CategoryScrollView!
    private var scrollView: UIScrollView!
    var inputDelegate: CandidateScrollViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor()
        self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        categoryScrollView = CategoryScrollView()
        categoryScrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(categoryScrollView)
        
        scrollView = UIScrollView()
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(scrollView)
        
        buttons = []
        for i in 1...5 {
            for emojiString in emojiStrings {
                var button = UIButton.buttonWithType(.System) as UIButton
                button.setTitle(emojiString, forState: .Normal)
                button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                button.backgroundColor = UIColor.whiteColor()
                button.setTranslatesAutoresizingMaskIntoConstraints(false)
                button.addTarget(self, action: "SELdidTapButton:", forControlEvents: .TouchUpInside)
                buttons.append(button)
                self.scrollView.addSubview(button)
            }
        }
        
        let hc = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200)
        view.addConstraints([hc])
        hc.priority = 999
        
        let ct = NSLayoutConstraint(item: categoryScrollView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0)
        let cl = NSLayoutConstraint(item: categoryScrollView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0)
        let cr = NSLayoutConstraint(item: categoryScrollView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0)
        view.addConstraints([ct,cl,cr])
        
        
        let a = NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: categoryScrollView, attribute: .Bottom, multiplier: 1, constant: 4)
        let b = NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0)
        let c = NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        let d = NSLayoutConstraint(item: scrollView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0)
        view.addConstraints([a,b,c,d])
    
        for (index,button) in enumerate(buttons) {
            var w,h,t,l: NSLayoutConstraint!
            if index != 0 {
                w = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: buttons[0], attribute: .Width, multiplier: 1, constant: 0)
                h = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: buttons[0], attribute: .Height, multiplier: 1, constant: 0)
            }
            else {
                buttonWidthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0)
                buttonHeightConstraint = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0)
                w = buttonWidthConstraint
                h = buttonHeightConstraint
            }
            
            if index%4 == 0 {
                t = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1, constant: 2)
            }
            else {
                t = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: buttons[index-1], attribute: .Bottom, multiplier: 1, constant: 4)
            }
            if index/4 == 0 {
                l = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1, constant: 2)
            }
            else {
                l = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: buttons[index-4], attribute: .Right, multiplier: 1, constant: 4)
            }
            scrollView.addConstraints([t,l,w,h])
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        buttonWidthConstraint?.constant = scrollView.frame.width/4 - 4
        buttonHeightConstraint?.constant = scrollView.frame.height/4 - 4
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func SELdidTapButton(sender: AnyObject?) {
        let button = sender as UIButton
        let title = button.titleForState(.Normal)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){ AudioServicesPlaySystemSound(1104)}
        inputDelegate?.didRecivedInputString(title!)
    }
    
}
