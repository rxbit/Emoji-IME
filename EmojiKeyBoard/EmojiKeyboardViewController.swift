//
//  EmojiKeyboardViewController.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/3/3.
//  Copyright (c) 2015年 wua. All rights reserved.
//

import UIKit
import AudioToolbox
import Snap

class EmojiKeyboardViewController: UIViewController {
    var inputDelegate: CandidateScrollViewDelegate?
    
    private let kHeight: CGFloat = 180
    
    private var buttons: [UIButton]! = []
    private var buttonWidthConstraint: NSLayoutConstraint?
    
    private var categoryScrollView: CategoryScrollView!
    private var scrollView: UIScrollView!
    
    override func viewWillAppear(animated: Bool) {
        addEmojiFaceButtons()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryScrollView = CategoryScrollView()
        categoryScrollView.layer.cornerRadius = 5
        categoryScrollView.cateDelegate = self
        view.addSubview(categoryScrollView)
        
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        view.addSubview(scrollView)
        
        categoryScrollView.snp_makeConstraints { make in
            make.top.equalTo(self.view).with.offset(2)
            make.left.equalTo(self.view).with.offset(4)
            make.right.equalTo(self.view).with.offset(-4)
        }
        
        scrollView.snp_makeConstraints { make in
            make.top.equalTo(self.categoryScrollView.snp_bottom).with.offset(4)
            make.left.equalTo(self.view).with.offset(2)
            make.right.equalTo(self.view).with.offset(-2)
            make.bottom.equalTo(self.view).with.offset(-2)
            make.height.equalTo(self.kHeight).priority(999)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonWidthConstraint?.constant = self.scrollView.frame.width/4 - 4
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
            button.addTarget(self, action: "SELdidTapButton:", forControlEvents: .TouchUpInside)
            button.layer.cornerRadius = 5
            buttons.append(button)
            self.scrollView.addSubview(button)
        }
        layoutButtons()
    }
    
    private func layoutButtons() {
        for (index,button) in enumerate(buttons) {
            button.snp_makeConstraints { make in
                if index != 0 {
                    make.size.equalTo(self.buttons[0])
                } else {
                    self.buttonWidthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0)
                    button.addConstraint(self.buttonWidthConstraint!)
                    make.height.equalTo(self.kHeight/4-3)
                }
                
                if index%4 == 0 {
                    make.top.equalTo(self.scrollView)
                } else {
                    make.top.equalTo(self.buttons[index-1].snp_bottom).with.offset(4)
                }
                if index/4 == 0 {
                    make.left.equalTo(self.scrollView).with.offset(2)
                }
                else {
                    make.left.equalTo(self.buttons[index-4].snp_right).with.offset(4)
                }
            }
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
