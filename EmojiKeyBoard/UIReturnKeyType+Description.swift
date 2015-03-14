//
//  UIReturnKeyType+Description.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/3/14.
//  Copyright (c) 2015年 wua. All rights reserved.
//

import UIKit

extension UIReturnKeyType: Printable {
    public var description: String {
        switch self {
        case .Default:
            return "Return"
        case .Done:
            return "Done"
        case .EmergencyCall:
            return "EmergencyCall"
        case .Go:
            return "Go"
        case .Google:
            return "Google"
        case .Join:
            return "Join"
        case .Next:
            return "Next"
        case .Route:
            return "Route"
        case .Search:
            return "Search"
        case .Send:
            return "Send"
        case .Yahoo:
            return "Yahoo"
        default:
            return "❤️"
        }
    }
}