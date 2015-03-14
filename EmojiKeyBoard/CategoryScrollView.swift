//
//  CatelogScrollView.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/3/2.
//  Copyright (c) 2015年 wua. All rights reserved.
//

import UIKit
import Snap

protocol CategoryScrollViewDelegate {
    func didChangeCategory(cate: String)
}

class CategoryScrollView: UIScrollView {
    private let kViewHeight: Int = 34
    private let kButtonWidth: Int = 48
    
    private var activiteButton: UIButton!
    private var buttons: [UIButton]!
    private var activeFlag: UIView!
    
    var cateDelegate: CategoryScrollViewDelegate?
    var currentCategoryTitle: String? {
        get {
            return activiteButton?.titleForState(.Normal)
        }
    }
    
    var acturllyContentSize: CGSize! {
        get{
            return CGSize(width: (kButtonWidth+2)*buttons.count+6, height: kViewHeight)
        }
    }
    
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
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 20, height: kViewHeight)
    }

    private func didInitView() {
        backgroundColor = KeyboardThemeManager.theme.CategoryBackgroundColor
        self.showsHorizontalScrollIndicator = false
        
        activeFlag = UIView()
        activeFlag.backgroundColor = KeyboardThemeManager.theme.CategoryActiveFlagColor
        activeFlag.layer.cornerRadius = 2.5
        addSubview(activeFlag)
        
        activeFlag.snp_makeConstraints { make in
            make.top.equalTo(self).offset(4)
            make.width.equalTo(5)
            make.height.equalTo(5)
        }
        
        
        buttons = []
        let tabStrings = EmojiFaceManager.sharedManager.emojiCategoryTitles
        for tabString in tabStrings {
            var button = UIButton.buttonWithType(.System) as UIButton
            button.setTitle(tabString, forState: .Normal)
            button.setTitleColor(KeyboardThemeManager.theme.CategoryButtonTextColorNormal, forState: .Normal)
            button.addTarget(self, action: "SELdidTapCategoryTabButton:", forControlEvents: .TouchUpInside)
            buttons.append(button)
            addSubview(button)
        }
        
        for (index,button) in enumerate(buttons) {
            button.snp_makeConstraints { make in
                if index == 0 {
                    make.leading.equalTo(self).offset(2)
                    self.activiteButton = button
                }
                else {
                    make.leading.equalTo(self.buttons[index-1].snp_trailing).offset(2)
                }
                make.centerY.equalTo(self)
                make.width.equalTo(self.kButtonWidth)
            }
        }
        setActiveTabwithButton(activiteButton)
    }
    
    private func setActiveTabwithButton(button: UIButton?) {
        if button == nil {
            activeFlag.hidden = true
        } else {
            activeFlag.hidden = false
            activiteButton.setTitleColor(KeyboardThemeManager.theme.CategoryButtonTextColorNormal, forState: .Normal)
            self.activiteButton = button
            activiteButton.setTitleColor(KeyboardThemeManager.theme.CategoryButtonTextColorActive, forState: .Normal)
            activeFlag.snp_updateConstraints { make in
                make.centerX.equalTo(self.activiteButton!)
                return
            }
            cateDelegate?.didChangeCategory(activiteButton.titleForState(.Normal)!)
        }
    }
    
    func SELdidTapCategoryTabButton(sender: AnyObject?) {
        let senderButton = sender as UIButton
        setActiveTabwithButton(senderButton)
    }
}
