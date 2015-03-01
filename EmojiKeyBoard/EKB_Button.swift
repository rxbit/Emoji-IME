//
//  EKB_Button.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/3/1.
//  Copyright (c) 2015年 wua. All rights reserved.
//

import UIKit

class EKB_Button: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.backgroundColor = UIColor(red: 157/255.0, green: 112/255.0, blue: 151/255.0, alpha: 1)
        self.layer.cornerRadius = 5
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
