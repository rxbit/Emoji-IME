//
//  EKB_Button.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/3/1.
//  Copyright (c) 2015年 wua. All rights reserved.
//

import UIKit
import AudioToolbox

class EKB_Button: UIButton {
    var frontColor: UIColor!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.backgroundColor = UIColor(red: 157/255.0, green: 112/255.0, blue: 151/255.0, alpha: 1)
        self.layer.cornerRadius = 5
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){ AudioServicesPlaySystemSound(1104)}
        frontColor = backgroundColor
        backgroundColor = UIColor(red: 233/255.0, green: 200/255.0, blue: 233/255.0, alpha: 1)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        backgroundColor = frontColor
    }


}
