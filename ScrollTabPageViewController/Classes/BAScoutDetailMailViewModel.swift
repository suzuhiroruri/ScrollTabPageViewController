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
    var interviewFixBenefitSubTitle: String?
    var interviewFixBenefitTitle: String?
    var benefitRemarks: String?
    var mailBody: String?

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

        mailHeader = "赤（あか、紅、朱、丹）は色のひとつで、熟したイチゴや血液のような色の総称。"

        interviewFixBenefitSubTitle = "書類なしでスグ面接♪"
        interviewFixBenefitTitle = "面接確約"

        benefitRemarks = "※面接交通費支給"
        benefitRemarks?.append("\n")
        benefitRemarks?.append("※来社特典あり")

        mailBody = "あ"
    }

    func numberOfCollectionCellAtSection() -> Int {
        return 7
    }

    func collectionCellText(indexPath: IndexPath) -> String {
        return "あーーーー"
    }

}
