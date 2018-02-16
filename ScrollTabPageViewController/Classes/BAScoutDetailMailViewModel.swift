//
//  BAScoutDetailMailViewModel.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/02/08.
//  Copyright © 2018年 EndouMari. All rights reserved.
//

import UIKit

class BAScoutDetailMailViewModel: NSObject {

    var isFromSubscribeList: Bool? = false
    var receivedDate: String?
    var mailHeader: String?
    var promisedInterviewBenefitSubTitle: String?
    var promisedInterviewBenefitTitle: String?
    var benefitRemarks: String? = ""
    var benefitRemarksArray: Array<String>?
    var mailBody: String?
    var appearDaysLeft: Int = 4
    var appearDaysLeftString: NSMutableAttributedString = NSMutableAttributedString()

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

        mailHeader = promisedInterviewBenefitTitle.isEmpty ? "あ" : "【" + promisedInterviewBenefitTitle + "】" + "あ"

        benefitRemarksArray = ["※面接交通費支給", "※来社特典あり"]
        guard let benefitRemarksArray = benefitRemarksArray else {
            return
        }
        for remark in benefitRemarksArray {
            guard let benefitRemarksIsEmpty: Bool = benefitRemarks?.isEmpty else {
                return
            }
            if !benefitRemarksIsEmpty {
                benefitRemarks?.append("\n")
            }
            benefitRemarks?.append(remark)
        }

        mailBody = "ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ"

        let attributeNormalBlack: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor.black
        ]
        let attributeBoldBlack: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 17.0)
        ]
        let attributeRed: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor.red,
            .font: UIFont.boldSystemFont(ofSize: 17.0)
        ]
        if appearDaysLeft >= 4, appearDaysLeft <= 7 {
            let stringFirst = NSAttributedString(string: "掲載終了まで残り", attributes: attributeNormalBlack)
            let stringSecond = NSAttributedString(string: appearDaysLeft.description, attributes: attributeBoldBlack)
            let stringThird = NSAttributedString(string: "日", attributes: attributeBoldBlack)

            appearDaysLeftString.append(stringFirst)
            appearDaysLeftString.append(stringSecond)
            appearDaysLeftString.append(stringThird)

        } else if appearDaysLeft >= 1, appearDaysLeft <= 3 {
            let stringFirst = NSAttributedString(string: "掲載終了まで残り", attributes: attributeNormalBlack)
            let stringSecond = NSAttributedString(string: appearDaysLeft.description, attributes: attributeRed)
            let stringThird = NSAttributedString(string: "日", attributes: attributeRed)

            appearDaysLeftString.append(stringFirst)
            appearDaysLeftString.append(stringSecond)
            appearDaysLeftString.append(stringThird)

        } else if appearDaysLeft < 1 {
            let string = NSAttributedString(string: "本日掲載終了", attributes: attributeRed)
            appearDaysLeftString.append(string)
        }
    }

    func numberOfCollectionCellAtSection() -> Int {
        return 7
    }

    func collectionCellText(indexPath: IndexPath) -> String {
        return "あーーーー"
    }

}
