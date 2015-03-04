//
//  EmojiFaceManager.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/3/5.
//  Copyright (c) 2015年 wua. All rights reserved.
//

import UIKit

private let sharedInstance = EmojiFaceManager()

class EmojiFaceManager: NSObject {
    class var sharedManager: EmojiFaceManager {
        return sharedInstance
    }
    
    private var emojiFaceDict: [String:[String]]!
    
    func loadEmojiFaceFromFileIfNeed() {
        var userDefault = NSUserDefaults.standardUserDefaults()
        let tmpDict = userDefault.dictionaryForKey("EmojiFace") as [String:[String]]?
        if tmpDict == nil {
            let faceDict = [
                "Keys": ["开心","快乐","悲伤","愤怒","不快","讨厌","自定义"],
                "开心": [">x<","OvO","QxQ","(-_-)"],
                "快乐": [">1<","OvO","QxQ","(-_-)"],
                "悲伤": [">2<","OvO","QxQ","(-_-)"],
                "愤怒": [">3<","OvO","QxQ","(-_-)"],
                "不快": [">4<","OvO","QxQ","(-_-)"],
                "讨厌": [">5<","OvO","QxQ","(-_-)"],
                "自定义": [">6<","OvO","QxQ","(-_-)"],
            ]
            userDefault.setObject(faceDict, forKey: "EmojiFace")
            emojiFaceDict = faceDict
        }
        else {
            emojiFaceDict = tmpDict!
        }
    }
    
    override init() {
        super.init()
        loadEmojiFaceFromFileIfNeed()
    }
    
    var emojiCategoryTitles: [String] {
        get{
            return emojiFaceDict["Keys"]!
        }
    }
    
    func getFaceswithCatagoryTitle(title: String?) -> [String] {
        if title == nil {
            return []
        }
        let rtn = emojiFaceDict[title!] as [String]?
        if rtn == nil {
            return []
        }
        return rtn!
    }
    
   
}
