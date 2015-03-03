//
//  HandwriteViewController.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/3/4.
//  Copyright (c) 2015年 wua. All rights reserved.
//

import UIKit

class HandwriteViewController: UIViewController {
    var inputDelegate: CandidateScrollViewDelegate?
    private var candidateScrollView: CandidateScrollView!
    private var handwriteView: CanvesView!
    private var candidateScrollViewTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        candidateScrollView = CandidateScrollView()
        candidateScrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        candidateScrollView.inputDelegate = inputDelegate
        view.addSubview(candidateScrollView)
        
        handwriteView = CanvesView()
        handwriteView.setTranslatesAutoresizingMaskIntoConstraints(false)
        handwriteView.delegate = candidateScrollView
        view.addSubview(handwriteView)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsUpdateConstraints()
    }
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        candidateScrollViewTopConstraint = NSLayoutConstraint(item: candidateScrollView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0)
        candidateScrollViewTopConstraint.priority = 999
        let cl = NSLayoutConstraint(item: candidateScrollView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 2)
        let cr = NSLayoutConstraint(item: candidateScrollView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -2)
        view.addConstraints([cl,cr,candidateScrollViewTopConstraint])
        
        let ht = NSLayoutConstraint(item: handwriteView, attribute: .Top, relatedBy: .Equal, toItem: candidateScrollView, attribute: .Bottom, multiplier: 1, constant: 4)
        ht.priority = 999
        let hl = NSLayoutConstraint(item: handwriteView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 4)
        let hb = NSLayoutConstraint(item: handwriteView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -4)
        let hr = NSLayoutConstraint(item: handwriteView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -4)
        let hh = NSLayoutConstraint(item: handwriteView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100)
//        hh.priority = 999
        view.addConstraints([ht,hl,hb,hr,hh])
    }
    
    override func viewDidLayoutSubviews() {
        candidateScrollViewTopConstraint.constant = (candidateScrollView.frame.height == 0) ? 0 : 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func deleteLatestPath() -> Bool {
        return handwriteView.deleteLatestPath()
    }
    
    func clearView() {
        handwriteView.clearView()
    }
    
}
