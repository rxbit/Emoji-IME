//
//  MyKeyboardButton.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/3/1.
//  Copyright (c) 2015年 wua. All rights reserved.
//

import UIKit
import AudioToolbox

class MyKeyboardButton: UIButton {
    private var frontColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInitView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitView()
    }
    
    private func didInitView() {
        self.backgroundColor = KeyboardThemeManager.theme.KeyboardButtonBackgroundColorNormal
        self.layer.cornerRadius = 5
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){ AudioServicesPlaySystemSound(1104)}
        frontColor = backgroundColor
        backgroundColor = KeyboardThemeManager.theme.KeyboardButtonBackgroundColorPressed
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        backgroundColor = frontColor
    }


}
