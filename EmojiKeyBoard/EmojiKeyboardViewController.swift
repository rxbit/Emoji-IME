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
    var inputDelegate: CandidateScrollViewDelegate?
    
    private let kHeight: CGFloat = 180
    
    private var buttons: [UIButton]! = []
    private var buttonWidthConstraint: NSLayoutConstraint?
    
    private var categoryScrollView: CategoryScrollView!
    private var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        categoryScrollView = CategoryScrollView()
        categoryScrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        categoryScrollView.layer.cornerRadius = 5
        categoryScrollView.cateDelegate = self
        view.addSubview(categoryScrollView)
        
        scrollView = UIScrollView()
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        view.addSubview(scrollView)
        
        let hc = NSLayoutConstraint(item: scrollView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: kHeight)
        view.addConstraints([hc])
        hc.priority = 999
        
        let ct = NSLayoutConstraint(item: categoryScrollView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 2)
        let cl = NSLayoutConstraint(item: categoryScrollView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 4)
        let cr = NSLayoutConstraint(item: categoryScrollView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -4)
        view.addConstraints([ct,cl,cr])
        
        
        let a = NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: categoryScrollView, attribute: .Bottom, multiplier: 1, constant: 4)
        let b = NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 2)
        let c = NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -2)
        let d = NSLayoutConstraint(item: scrollView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -2)
        view.addConstraints([a,b,c,d])
        
        addEmojiFaceButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonWidthConstraint?.constant = scrollView.frame.width/4 - 4
        categoryScrollView.contentSize = categoryScrollView.acturllyContentSize
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(buttons.count/16+1), height: kHeight)
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
    
    private func addEmojiFaceButtons() {
        let titleStrings = EmojiFaceManager.sharedManager.getFaceswithCatagoryTitle(categoryScrollView.currentCategoryTitle)
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons.removeAll(keepCapacity: false)
        
        for emojiString in titleStrings {
            var button = UIButton.buttonWithType(.System) as UIButton
            button.setTitle(emojiString, forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.backgroundColor = UIColor.whiteColor()
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            button.addTarget(self, action: "SELdidTapButton:", forControlEvents: .TouchUpInside)
            button.layer.cornerRadius = 5
            buttons.append(button)
            self.scrollView.addSubview(button)
        }
        layoutButtons()
    }
    
    private func layoutButtons() {
        for (index,button) in enumerate(buttons) {
            var w,h,t,l: NSLayoutConstraint!
            if index != 0 {
                w = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: buttons[0], attribute: .Width, multiplier: 1, constant: 0)
                h = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: buttons[0], attribute: .Height, multiplier: 1, constant: 0)
            }
            else {
                buttonWidthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0)
                h = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: kHeight/4-3)
                w = buttonWidthConstraint
            }
            
            if index%4 == 0 {
                t = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1, constant: 0)
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
    
}

extension EmojiKeyboardViewController: CategoryScrollViewDelegate {
    func didChangeCategory(cate: String) {
        addEmojiFaceButtons()
        view.setNeedsLayout()
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
}
