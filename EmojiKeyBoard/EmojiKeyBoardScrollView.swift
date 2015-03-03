//
//  EmojiKeyBoardScrollView.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/3/3.
//  Copyright (c) 2015年 wua. All rights reserved.
//

import UIKit
import AudioToolbox

class EmojiKeyBoardScrollView: UIScrollView {
    private var buttons: [UIButton]!
    private var emojiStrings = ["(^_^)","(-v-)","(QAQ)","(QAO)"]
    var inputDelegate: CandidateScrollerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInitView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitView()
    }
    
    override init() {
        super.init()
    }
    
    func didInitView() {
        backgroundColor = UIColor.blueColor()
        buttons = []
        for i in 1...4 {
        for emojiString in emojiStrings {
            var button = UIButton.buttonWithType(.System) as UIButton
            button.setTitle(emojiString, forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.backgroundColor = UIColor.whiteColor()
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            button.addTarget(self, action: "SELdidTapButton:", forControlEvents: .TouchUpInside)
            buttons.append(button)
            addSubview(button)
        }
        }
        
        for (index,button) in enumerate(buttons) {
            var t,l: NSLayoutConstraint!
//            let w = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.bounds.width/4-4)
//            let h = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.bounds.height/4-4)
            let w = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 80)
            let h = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 32)
            if index%4 == 0 {
                t = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 2)
            }
            else {
                t = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: buttons[index-1], attribute: .Bottom, multiplier: 1, constant: 4)
            }
            if index/4 == 0 {
                l = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 2)
            }
            else {
                l = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: buttons[index-4], attribute: .Right, multiplier: 1, constant: 4)
            }
            addConstraints([t,l,w,h])
        }
    }
    
    func SELdidTapButton(sender: AnyObject?) {
        let button = sender as UIButton
        let title = button.titleForState(.Normal)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){ AudioServicesPlaySystemSound(1104)}
        inputDelegate?.didRecivedInputString(title!)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
