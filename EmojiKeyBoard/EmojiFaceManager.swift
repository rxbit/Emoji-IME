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
    
    //TODO: load form json
    private let faceDict = [
        "Keys": ["愉悦","高兴","无奈","惊讶","愤怒","期待","讨厌","自定义"],
        "愉悦": ["d(d＇∀＇)","d(`･∀･)b","(*´∀`)~♥","σ`∀´)σ","_(:3 」∠ )_","(́◉◞౪◟◉‵)","(｡◕∀◕｡)","ヽ(́◕◞౪◟◕‵)ﾉ",
            "ヽ(✿ﾟ▽ﾟ)ノ","థ౪థ","(◔౪◔)","ლ(╹◡╹ლ)","(✪ω✪)","(◔⊖◔)つ","(๑´ڡ`๑)","(´▽`ʃ♡ƪ)","_(:3 ⌒ﾞ)_","(灬ºωº灬)",
            "(๑ơ ₃ ơ)♥","♥(´∀` )人","(^ρ^)/","(●´ω｀●)ゞ","(≧∀≦)ゞ","(,,ﾟДﾟ)","( • ̀ω•́ )","( ﾒ∀・)","(*ﾟーﾟ)","(｢･ω･)｢","＼(●´ϖ`●)／","＼(●´ϖ`●)／"],
        "高兴": ["(ﾉ>ω<)ﾉ","d(`･∀･)b","(*´∀`)~♥","ξ( ✿＞◡❛)","(^_っ^)","_(:3 」∠ )_","ヽ(́◕◞౪◟◕‵)ﾉ","ヽ(✿ﾟ▽ﾟ)ノ",
            "థ౪థ","ლ(╹◡╹ლ)","(◔⊖◔)つ","(∂ω∂)","(๑´ڡ`๑)","(๑´ڡ`๑)","(๑• . •๑)","٩(｡・ω・｡)﻿و","♥(´∀` )人","(^ρ^)/","(๑•̀ㅂ•́)و✧","(♛‿♛)","( శ 3ੜ)～♥"],
        "无奈": ["(´c_`)","(´,_ゝ`)","(´ﾟдﾟ`)","(๑•́ ₃ •̀๑)","╮(╯_╰)╭","(　◜◡‾)","( ˘･з･)","ρ(・ω・、)","(ヾﾉ･ω･`)","(-_-)","(눈‸눈)","╮(′～‵〞)╭","(´-ω-｀)"],
        "惊讶": ["(((ﾟДﾟ;)))","Σ(*ﾟдﾟﾉ)ﾉ","(д) ﾟﾟ","(((ﾟдﾟ)))","(|||ﾟдﾟ)","Σ( ° △ °)","┌|◎o◎|┘","( • ̀ω•́ )","＼(●o○;)ノ","Σ(°Д°;","∑(￣□￣;)","(ﾟдﾟ)","ㅇㅅㅇ"],
        "愤怒": ["(ﾟ皿ﾟﾒ)","(ﾒ ﾟ皿ﾟ)ﾒ","(#`Д´)ﾉ","(#`皿´)","(-`ェ´-╬)","(╬ﾟдﾟ)","ヽ(`Д´)ノ","(╬ﾟ ◣ ﾟ)","(๑•ૅω•´๑)","(╯•̀ὤ•́)╯","(ﾒﾟДﾟ)ﾒ"],
        "期待": ["(,,・ω・,,)","ლ(╹◡╹ლ)","(✪ω✪)","(´ΘωΘ`)","(ㅅ˘ㅂ˘)","(,,ﾟДﾟ)","(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧","(^ρ^)/","ε(*´･∀･｀)зﾞ","(⁎⁍̴̛ᴗ⁍̴̛⁎)‼ "],
        "讨厌": [">5<","OvO","QxQ","(-_-)","QOQ"],
        "自定义": [">6<","OvO","QxQ","(-_-)","LoL"],
    ]
    
    private var emojiFaceDict: [String:[String]]!
    
    override init() {
        super.init()
        var userDefault = NSUserDefaults.standardUserDefaults()
        let tmpDict = userDefault.dictionaryForKey("EmojiFace") as? [String:[String]]
        if let tmpDict = tmpDict {
            emojiFaceDict = tmpDict
        } else {
            userDefault.setObject(faceDict, forKey: "EmojiFace")
            emojiFaceDict = faceDict
        }
    }
    
    var emojiCategoryTitles: [String] {
            return emojiFaceDict["Keys"]!
    }
    
    func getFaceswithCatagoryTitle(title: String?) -> [String] {
        if let title = title {
            let rtn = emojiFaceDict[title] as [String]?
            return (rtn != nil) ? rtn! : []
        }
        return []
    }
}
