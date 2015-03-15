//
//  KeyboardThemeManager.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/3/14.
//  Copyright (c) 2015年 wua. All rights reserved.
//

private let _sharedInstance = KeyboardThemeManager()

enum KeyboardThemeName {
    case Default
}

class KeyboardThemeManager {
    class var sharedInstance: KeyboardThemeManager {
        return _sharedInstance
    }
    class var theme: KeyboardTheme {
        return _sharedInstance.theme
    }
    
    var theme: KeyboardTheme! = KeyboardTheme()
    
    func changeThemeWithThemeName(themeName: KeyboardThemeName) {
        switch themeName {
        case .Default:
            theme = KeyboardTheme()
        }
    }
}

class KeyboardTheme {
    var KeyboardBackgroundColor: UIColor {
        return UIColor(red: 234/255.0, green: 176/255.0, blue: 227/255.0, alpha: 1)
    }
    
    var KeyboardButtonBackgroundColorNormal: UIColor {
        return UIColor(red: 157/255.0, green: 112/255.0, blue: 151/255.0, alpha: 1)
    }
    
    var KeyboardButtonBackgroundColorPressed: UIColor {
        return UIColor(red: 233/255.0, green: 200/255.0, blue: 233/255.0, alpha: 1)
    }
    
    var CandidateButtonBackGroundColorNormal: UIColor {
        return UIColor(white: 0.95, alpha: 1)
    }
    
    var CandidateButtonTextColorNormal: UIColor {
        return UIColor.blackColor()
    }
    
    var CandidateBackgroundColor: UIColor {
        return UIColor.whiteColor()
    }
    
    var CanvesBackgroundColor: UIColor {
        return UIColor.whiteColor()
    }
    
    var CanvesBrushColor: UIColor {
        return UIColor.blackColor()
    }
    
    var CategoryBackgroundColor: UIColor {
        return UIColor.whiteColor()
    }
    
    var CategoryButtonTextColorNormal: UIColor {
        return UIColor.grayColor()
    }
    
    var CategoryActiveFlagColor: UIColor {
        return UIColor.purpleColor()
    }
    
    var CategoryButtonTextColorActive: UIColor {
        return UIColor.grayColor()
    }
    
    var KeyboardSpaceButtonColorNormal: UIColor {
        return UIColor.whiteColor()
    }
    
    var EmojiKeyboardButtonTextColor: UIColor {
        return UIColor.blackColor()
    }
    
    var EmojiKeyboardBackgroundColor: UIColor {
        return UIColor.whiteColor()
    }
    
    var KeyboardButtonTextColorDark: UIColor {
        return UIColor.blackColor()
    }

    var KeyboardButtonTextColorLight: UIColor {
        return UIColor.whiteColor()
    }
}