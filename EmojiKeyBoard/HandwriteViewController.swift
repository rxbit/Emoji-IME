//
//  HandwriteViewController.swift
//  Emoji-IME
//
//  Created by Wuhua Dai on 15/3/4.
//  Copyright (c) 2015年 wua. All rights reserved.
//

import UIKit
import Snap

class HandwriteViewController: UIViewController {
    var inputDelegate: CandidateScrollViewDelegate?
    private var candidateScrollView: CandidateScrollView!
    private var handwriteView: CanvesView!
    private var candidateScrollViewTopConstraint: Constraint?
    private var candidateScrollViewHeightConstraint: Constraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        candidateScrollView = CandidateScrollView()
        candidateScrollView.inputDelegate = self
        candidateScrollView.layer.cornerRadius = 5
        view.addSubview(candidateScrollView)
        
        handwriteView = CanvesView()
        handwriteView.delegate = self
        view.addSubview(handwriteView)
        
        addLayoutConstriant()
    }
    
    private func addLayoutConstriant() {
        candidateScrollView.snp_makeConstraints { make in
            self.candidateScrollViewTopConstraint = make.top.equalTo(self.view).priority(999)
            self.candidateScrollViewHeightConstraint = make.height.equalTo(0).priority(999)
            make.leading.equalTo(self.view).with.offset(4)
            make.trailing.equalTo(self.view).with.offset(-4)
        }
        
        handwriteView.snp_makeConstraints { make in
            make.top.equalTo(self.candidateScrollView.snp_bottom).with.offset(4).priority(999)
            make.left.equalTo(self.view).with.offset(4)
            make.right.equalTo(self.view).with.offset(-4)
            make.bottom.equalTo(self.view).with.offset(-2)
            make.height.equalTo(180)
        }
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

extension HandwriteViewController: EmojiImputDelegate {
    func didRecivedEmojiStrings(strings: [String]?) {
        candidateScrollViewTopConstraint?.uninstall()
        candidateScrollViewHeightConstraint?.uninstall()
        var c = (top: 0,height: 0)
        if strings == nil || strings!.count == 0 {
            c = (0,0)
        } else {
            c = (2,34)
            candidateScrollView.updateButtonsWithStrings(strings!)
        }
        self.candidateScrollView.snp_makeConstraints { make in
            self.candidateScrollViewTopConstraint = make.top.equalTo(self.view).with.offset(c.top)
            self.candidateScrollViewHeightConstraint = make.height.equalTo(c.height)
        }
    }
}

extension HandwriteViewController: CandidateScrollViewDelegate {
    func didRecivedInputString(string: String) {
        inputDelegate?.didRecivedInputString(string)
        clearView()
    }
}
