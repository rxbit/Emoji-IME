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

    override func viewDidLoad() {
        super.viewDidLoad()
        candidateScrollView = CandidateScrollView()
        candidateScrollView.inputDelegate = self
        candidateScrollView.layer.cornerRadius = 5
        view.addSubview(candidateScrollView)
        
        handwriteView = CanvesView()
        handwriteView.delegate = self
        view.addSubview(handwriteView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addLayoutConstriant()
    }
    
    private func addLayoutConstriant() {
        candidateScrollView.snp_makeConstraints { make in
            make.top.equalTo(self.view).priorityHigh()
            make.height.equalTo(0).priorityHigh()
            make.left.equalTo(self.view).offset(4)
            make.right.equalTo(self.view).offset(-4).priorityHigh()
        }
        
        handwriteView.snp_makeConstraints { make in
            make.top.equalTo(self.candidateScrollView.snp_bottom).offset(4).priorityHigh()
            make.left.equalTo(self.view).offset(4)
            make.right.equalTo(self.view).offset(-4).priorityHigh()
            make.bottom.equalTo(self.view).offset(-2)
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

    private func didRecivedEmojiStrings(strings: [String]?) {
        var c = (top: 0,height: 0)
        if strings == nil || strings!.count == 0 {
            c = (0,0)
        } else {
            c = (2,34)
            candidateScrollView.updateButtonsWithStrings(strings!)
        }
        self.candidateScrollView.snp_updateConstraints { make in
            make.top.equalTo(self.view).offset(c.top)
            make.height.equalTo(c.height)
        }
    }
}

extension HandwriteViewController: EmojiImputDelegate {
    func didHandwriteEndedAndStartReconigze(sender: CanvesView, viewImage: UIImage) {
        if sender == self.handwriteView {
            if let strings = TestCV.sharedInstance().DetectEmojiStringsWithImage(viewImage) as [String]? {
                self.didRecivedEmojiStrings(strings)
            }
        }
    }
    
    func didHandwriteEndedAndNoPath(sender: CanvesView) {
        if sender == self.handwriteView { self.didRecivedEmojiStrings(nil) }
    }
    

}

extension HandwriteViewController: CandidateScrollViewDelegate {
    func didRecivedInputString(string: String) {
        inputDelegate?.didRecivedInputString(string)
        clearView()
    }
}
