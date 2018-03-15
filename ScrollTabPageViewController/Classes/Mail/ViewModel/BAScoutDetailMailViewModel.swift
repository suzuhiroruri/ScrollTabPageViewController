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
    // スカウトメール受信日
    var receivedDate: String?
    // 表示期限
    var displayLimitDate: String?
    // スカウトメールヘッダー
    var mailHeader: String?
    // 面接確約特典サブタイトル
    var promisedInterviewBenefitSubTitle: String?
    // 面接確約特典タイトル
    var promisedInterviewBenefitTitle: String?
    // 特典アイコン配列
    var benefitIconArray: Array<String> = []
    // 直接採用企業かどうか
    var isDirectEmployCompany: Bool?  = true

    // スカウト特典備考
    var benefitRemarks: String? = ""
    // スカウトメール本文
    var mailBody: String?
    // 掲載終了までの残り日数
    var appearDaysLeftString: NSMutableAttributedString = NSMutableAttributedString()

    // 面接確約特典のenum
    enum promisedInterviewBenefit: Int {
        case promisedInterview      = 0
        case exemptionFirstInterview
        case officerInterview
        case presidentInterview
    }

    override init() {
        super.init()

        // スカウトメール受信日
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

        if isFromSubscribeList {
            // 応募済みの場合
            displayLimitDate = "表示期限 :"
            displayLimitDate?.append("2017/11/11")
        } else {
            // 未応募の場合
            displayLimitDate = "受信日 :"
            displayLimitDate?.append("2017/11/11")
        }

        // 面接確約特典サブタイトル
        promisedInterviewBenefitSubTitle = "書類なしでスグ面接♪"

        // 面接確約特典タイトル
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

        // スカウトメールヘッダー
        mailHeader = promisedInterviewBenefitTitle.isEmpty ? "あ" : "【" + promisedInterviewBenefitTitle + "】" + "ああああああああああああああああああああ"

        guard let isDirectEmployCompany = isDirectEmployCompany else {
            return
        }

        let tripInterviewFlag = true
        if tripInterviewFlag {
            let iconString = isDirectEmployCompany ? "出張面接" : "出張登録会"
            benefitIconArray.append(iconString)
        }

        let weekendFlag = true
        if weekendFlag {
            let iconString = isDirectEmployCompany ? "土日面接可能" : "土日登録会"
            benefitIconArray.append(iconString)
        }

        let nightInterviewFlag = true
        if nightInterviewFlag {
            let iconString = isDirectEmployCompany ? "夜間採用" : "夜間登録会"
            benefitIconArray.append(iconString)
        }

        let interviewTransportProvideKind = 1
        if interviewTransportProvideKind == 1 || interviewTransportProvideKind == 2 {
            let iconString = isDirectEmployCompany ? "面接交通費支給" : "登録会交通費支給"
            benefitIconArray.append(iconString)
        }

        let visitCompanyInterviewFlag = true
        if visitCompanyInterviewFlag {
            let iconString = "来社特典あり"
            benefitIconArray.append(iconString)
        }

        // 特典アイコン配列
        var benefitRemarksArray: Array<String> = []
        let interviewTransportSupplyInfo = "面接交通費支給内容"
        if interviewTransportProvideKind == 1 {
            let remarkString = "※面接交通費支給 : 全額支給 (" + interviewTransportSupplyInfo + ")"
            benefitRemarksArray.append(remarkString)
        } else if interviewTransportProvideKind == 2 {
            let transportSupplyLimit = 1000.description
            let remarkString = "※面接交通費支給 : 上限全額" + transportSupplyLimit + "円までの一部支給 (" + interviewTransportSupplyInfo + ")"
            benefitRemarksArray.append(remarkString)
        }

        if visitCompanyInterviewFlag {
            let visitCompanyInterviewBenefitInfo = "特典内容"
            let remarkString = "※来社特典あり : " + visitCompanyInterviewBenefitInfo
            benefitRemarksArray.append(remarkString)
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

		// スカウトメール本文
        mailBody = "最新のフードデリバリーサービス\nUber Eats（ウーバーイーツ）のお料理を配達するお仕事！\n【1】アプリを開くとレストランから配達リクエストが届く\n▼\n【2】自転車や原付バイクで料理を受け取り、配達スタート!\n▼\n【3】注文者に料理を届けて、アプリで完了ボタンをタップ!\n★殆どの人がデリバリー初心者！\n★配達バッグは貸し出し有!\n★自分の自転車・原付バイク(125cc以下)で稼働OK！\n★お仕事は私服でOK!"

        // 掲載終了までの残り日数
        let attributeNormalBlack: [NSAttributedStringKey: Any] = [
            NSForegroundColorAttributeName as NSString: UIColor.black
        ]
        let attributeBoldBlack: [NSAttributedStringKey: Any] = [
            NSForegroundColorAttributeName as NSString: UIColor.black,
            NSFontAttributeName as NSString: UIFont.boldSystemFont(ofSize: 17.0)
        ]
        let attributeRed: [NSAttributedStringKey: Any] = [
            NSForegroundColorAttributeName as NSString: UIColor.red,
            NSFontAttributeName as NSString: UIFont.boldSystemFont(ofSize: 17.0)
        ]
        let appearDaysLeft: Int = 8

        // TODO:AttributedStringはバイトルのEXTENSIONを使う
        if appearDaysLeft >= 4, appearDaysLeft <= 7 {
            let stringFirst = NSAttributedString(string: "掲載終了まで残り ", attributes: attributeNormalBlack as [String: Any])
            let stringSecond = NSAttributedString(string: appearDaysLeft.description, attributes: attributeBoldBlack as [String: Any])
            let stringThird = NSAttributedString(string: " 日", attributes: attributeBoldBlack as [String: Any])

            appearDaysLeftString.append(stringFirst)
            appearDaysLeftString.append(stringSecond)
            appearDaysLeftString.append(stringThird)

        } else if appearDaysLeft >= 1, appearDaysLeft <= 3 {
            let stringFirst = NSAttributedString(string: "掲載終了まで残り ", attributes: attributeNormalBlack as [String: Any])
            let stringSecond = NSAttributedString(string: appearDaysLeft.description, attributes: attributeRed as [String: Any])
            let stringThird = NSAttributedString(string: " 日", attributes: attributeBoldBlack as [String: Any])

            appearDaysLeftString.append(stringFirst)
            appearDaysLeftString.append(stringSecond)
            appearDaysLeftString.append(stringThird)

        } else if appearDaysLeft < 1 {
            let string = NSAttributedString(string: "本日掲載終了", attributes: attributeRed as [String: Any])
            appearDaysLeftString.append(string)
        }
    }

    // コレクションセルのセル数
    func numberOfCollectionCellAtSection() -> Int {
        return benefitIconArray.count
    }

    // コレクションセルの文字列
    func collectionCellText(indexPath: IndexPath) -> String {
        return benefitIconArray[indexPath.row]
    }

}
