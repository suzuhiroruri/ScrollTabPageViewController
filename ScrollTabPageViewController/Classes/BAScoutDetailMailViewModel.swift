//
//  BAScoutDetailMailViewModel.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/02/08.
//  Copyright © 2018年 EndouMari. All rights reserved.
//

import UIKit

class BAScoutDetailMailViewModel: NSObject {
    
    var isFromSubscribeList:Bool? = false
    var receivedDate: String?
    var mailHeader: String?
    var promisedInterviewBenefitSubTitle: String?
    var promisedInterviewBenefitTitle: String?
    var benefitRemarks: String? = ""
    var benefitRemarksArray: Array<String>?
    var mailBody: String?
    
    enum promisedInterviewBenefit: Int {
        case promisedInterview      = 0
        case exemptionFirstInterview
        case officerInterview
        case presidentInterview
    }

    override init() {
        super.init()
        let f = DateFormatter()
        
        guard let isFromSubscribeList = isFromSubscribeList else {
            return
        }
        f.timeStyle = isFromSubscribeList ? .medium:.none
        f.dateStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        let now = Date()

        receivedDate = "受信日 :"
        receivedDate?.append(f.string(from: now))
        
        promisedInterviewBenefitSubTitle = "書類なしでスグ面接♪"
        switch promisedInterviewBenefit(rawValue: 2) {
        case .promisedInterview?:
            promisedInterviewBenefitTitle = "面接確約"
        case .exemptionFirstInterview?:
            promisedInterviewBenefitTitle = "一次面接免除"
        case .officerInterview?:
            promisedInterviewBenefitTitle = "いきなり役員面接"
        case .presidentInterview?:
            promisedInterviewBenefitTitle = "いきなり社長面接"
        case .none:
            promisedInterviewBenefitTitle = ""
        }
        guard let promisedInterviewBenefitTitle = promisedInterviewBenefitTitle else {
            return
        }
        
        if promisedInterviewBenefitTitle.count > 0 {
            mailHeader = "【" + promisedInterviewBenefitTitle + "】" + "あ"
        } else {
            mailHeader = "あ"
        }

        benefitRemarksArray = ["※面接交通費支給","※来社特典あり"]
        guard let benefitRemarksArray = benefitRemarksArray else {
            return
        }
        for remark in benefitRemarksArray {
            guard let benefitRemarksCount:Int = benefitRemarks?.count else {
                return
            }
            if benefitRemarksCount > 0 {
                benefitRemarks?.append("\n")
            }
            benefitRemarks?.append(remark)
        }
        
        mailBody = "ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ"
    }

    func numberOfCollectionCellAtSection() -> Int {
        return 7
    }

    func collectionCellText(indexPath: IndexPath) -> String {
        return "あーーーー"
    }

}
