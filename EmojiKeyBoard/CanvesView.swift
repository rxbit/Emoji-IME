//
//  CanvesView.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 14/12/28.
//  Copyright (c) 2014年 wua. All rights reserved.
//

import UIKit

protocol EmojiImputDelegate {
    func didRecivedEmojiStrings(strings: [String]?)
}

class CanvesView: UIView {
    var delegate: EmojiImputDelegate?
    private var arrayStrokes:[[CGPoint]] = []
    
    override init() {
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInitView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didInitView()
    }
    
    private func didInitView() {
        self.backgroundColor = KeyboardThemeManager.theme.CanvesBackgroundColor
        //self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        self.contentMode = .Redraw
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        println("开始触摸つ(^v^)つ")
        var arrayPointsInStroke:[CGPoint] = []
        self.arrayStrokes.append(arrayPointsInStroke)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        println("摩擦～摩擦～～")
        if let touch = touches.anyObject() as? UITouch {
            let point = touch.locationInView(self)
            if !self.arrayStrokes.isEmpty {
                self.arrayStrokes[self.arrayStrokes.count - 1].append(point)
            }
        }
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        println("Stop!!")
        if self.arrayStrokes.last!.count < 2 {
            self.arrayStrokes.removeLast()
        }
        startDetect()
    }
    
    private func startDetect() {
        if self.arrayStrokes.isEmpty {
            self.delegate?.didRecivedEmojiStrings(nil)
            return
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen().scale)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let strings = TestCV.sharedInstance().DetectEmojiStringsWithImage(image) as [String]?
        self.delegate?.didRecivedEmojiStrings(strings)
    }
    
    override func drawRect(rect: CGRect) {
        println("绘画开始")
        KeyboardThemeManager.theme.CanvesBrushColor.setStroke()
        for array in self.arrayStrokes {
            var line = UIBezierPath()
            line.lineWidth = 10
            line.moveToPoint(array.first!)
            for point in array {
                line.addLineToPoint(point)
            }
            line.stroke()
        }
    }
    
    func deleteLatestPath() -> Bool {
        if self.arrayStrokes.count > 0 {
            self.arrayStrokes.removeLast()
            setNeedsDisplay()
            startDetect()
            return true
        }
        else {
            return false
        }
    }
    
    func clearView() {
        arrayStrokes.removeAll(keepCapacity: false)
        setNeedsDisplay()
        startDetect()
    }

}
