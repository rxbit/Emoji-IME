//
//  CandidateScrollerView.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/2/15.
//  Copyright (c) 2015年 wua. All rights reserved.
//

import UIKit
import AudioToolbox

protocol CandidateScrollViewDelegate: class {
    func didRecivedInputString(string:String)
}

class CandidateScrollView: UIScrollView {
    weak var inputDelegate: CandidateScrollViewDelegate?
    private var buttons: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInitView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitView()
    }
    
    private func didInitView() {
        self.backgroundColor = KeyboardThemeManager.theme.CandidateBackgroundColor
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 20, height: 34)
    }
    
    func updateButtonsWithStrings(strings: [String]) {
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons = []
        for string in strings {
            let button = UIButton.buttonWithType(.System) as! UIButton
            button.setTitle(string, forState: .Normal)
            button.sizeToFit()
            button.backgroundColor = KeyboardThemeManager.theme.CandidateButtonBackGroundColorNormal
            button.setTitleColor(KeyboardThemeManager.theme.CandidateButtonTextColorNormal, forState: .Normal)
            button.addTarget(self, action: "SELdidTapButton:", forControlEvents: .TouchUpInside)
            button.layer.cornerRadius = 3
            buttons.append(button)
            self.addSubview(button)
        }
        
        for (index, button) in enumerate(buttons) {
            //add constraints
            button.snp_makeConstraints { make in
                make.top.equalTo(self).with.offset(2)
                make.bottom.equalTo(self)
                if index == 0 {
                    make.leading.equalTo(self).with.offset(2)
                } else {
                    make.leading.equalTo(self.buttons[index-1].snp_trailing).with.offset(4)
                }
                if index == self.buttons.count - 1 {
                    make.trailing.equalTo(self).with.offset(2)
                }
            }
        }
    }

    func SELdidTapButton(sender: AnyObject?) {
        let button = sender as! UIButton
        let title = button.titleForState(.Normal)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){ AudioServicesPlaySystemSound(1104)}
        inputDelegate?.didRecivedInputString(title!)
    }
}