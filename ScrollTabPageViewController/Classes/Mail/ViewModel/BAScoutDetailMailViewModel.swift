//
//  BAScoutDetailMailViewModel.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/02/08.
//  Copyright © 2018年 EndouMari. All rights reserved.
//

import UIKit

class BAScoutDetailMailViewModel {

    /// TODO:仮値。応募済みの動線ができたらちゃんと使う
    /// 動線が未応募か応募済みか
    var isFromSubscribeList: Bool = false
    /// 応募日時
    private(set) var subscribeDate: String = ""
    /// スカウトメール受信日
    private(set) var receivedDate: String = ""
    /// 表示期限
    private(set) var displayLimitDate: String = ""
    /// スカウトメールヘッダー
    private(set) var mailHeader: String = ""
    /// 面接確約特典タイトル
    private(set) var promisedInterviewBenefitTitle: String = ""
    /// 特典アイコン配列
    private(set) var benefitIconArray: Array<String> = []
    /// 直接採用企業かどうか
    private(set) var isDirectEmployCompany: Bool = true
    /// スカウト特典備考
    private(set) var benefitRemarks: String? = ""
    /// スカウトメール本文
    private(set) var mailBody: String = ""
    /// 掲載終了までの残り日数
    private(set) var appearDaysLeftString: NSMutableAttributedString = NSMutableAttributedString()

    /// 面接確約特典のenum
    enum promisedInterviewBenefit: Int {
        case promisedInterview      = 0
        case exemptionFirstInterview
        case officerInterview
        case presidentInterview
    }

    // TODO:通信処理が出来次第修正
    func updateMailData() {
        /// スカウトメール受信日
        /// TODO:現在は仮値。通信処理が完成したら修正
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        let now = Date()
        let receivedDateString = formatter.string(from: now)
        receivedDate = "受信日 :"
        receivedDate.append(receivedDateString)

        /// TODO:isFromSubscribeListは仮値。応募済みの動線ができたらちゃんと使う
        if isFromSubscribeList {
            /// 応募済みの場合
            formatter.timeStyle = .medium
            let subscribeDateString = formatter.string(from: now)
            subscribeDate = "応募日時 :"
            subscribeDate.append(subscribeDateString)
            displayLimitDate = "表示期限 :"
            displayLimitDate.append("2017/11/11")
        } else {
            /// 未応募の場合
            displayLimitDate = "受信日 :"
            displayLimitDate.append(receivedDateString)
        }

        /// 面接確約特典タイトル
        /// TODO:現在は仮値。通信処理が完成したら修正
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

        /// スカウトメールヘッダー
        /// TODO:現在は仮値。通信処理が完成したら修正
        mailHeader = promisedInterviewBenefitTitle.isEmpty ? "あ" : "【" + promisedInterviewBenefitTitle + "】" + "ああああああああああああああああああああ"

        /// TODO:現在は仮値。通信処理が完成したら修正
        let tripInterviewFlag = true
        if tripInterviewFlag {
            let iconString = isDirectEmployCompany ? "出張面接" : "出張登録会"
            benefitIconArray.append(iconString)
        }

        /// TODO:現在は仮値。通信処理が完成したら修正
        let weekendFlag = true
        if weekendFlag {
            let iconString = isDirectEmployCompany ? "土日面接可能" : "土日登録会"
            benefitIconArray.append(iconString)
        }

        /// TODO:現在は仮値。通信処理が完成したら修正
        let nightInterviewFlag = true
        if nightInterviewFlag {
            let iconString = isDirectEmployCompany ? "夜間採用" : "夜間登録会"
            benefitIconArray.append(iconString)
        }

        /// TODO:現在は仮値。通信処理が完成したら修正
        let interviewTransportProvideKind = 1
        if interviewTransportProvideKind == 1 || interviewTransportProvideKind == 2 {
            let iconString = isDirectEmployCompany ? "面接交通費支給" : "登録会交通費支給"
            benefitIconArray.append(iconString)
        }

        /// TODO:現在は仮値。通信処理が完成したら修正
        let visitCompanyInterviewFlag = true
        if visitCompanyInterviewFlag {
            let iconString = "来社特典あり"
            benefitIconArray.append(iconString)
        }

        /// 特典アイコン配列
        /// TODO:現在は仮値。通信処理が完成したら修正
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

        /// TODO:現在は仮値。通信処理が完成したら修正
        if visitCompanyInterviewFlag {
            let visitCompanyInterviewBenefitInfo = "特典内容"
            let remarkString = "※来社特典あり : " + visitCompanyInterviewBenefitInfo
            benefitRemarksArray.append(remarkString)
        }

        /// 特典備考
        /// TODO:現在は仮値。通信処理が完成したら修正
        for remark in benefitRemarksArray {
            guard let benefitRemarksIsEmpty: Bool = benefitRemarks?.isEmpty else {
                return
            }
            if !benefitRemarksIsEmpty {
                benefitRemarks?.append("\n")
            }
            benefitRemarks?.append(remark)
        }

        /// スカウトメール本文
        /// TODO:現在は仮値。通信処理が完成したら修正
        mailBody = "最新のフードデリバリーサービス\nUber Eats（ウーバーイーツ）のお料理を配達するお仕事！\n【1】アプリを開くとレストランから配達リクエストが届く\n▼\n【2】自転車や原付バイクで料理を受け取り、配達スタート!\n▼\n【3】注文者に料理を届けて、アプリで完了ボタンをタップ!\n★殆どの人がデリバリー初心者！\n★配達バッグは貸し出し有!\n★自分の自転車・原付バイク(125cc以下)で稼働OK！\n★お仕事は私服でOK!"

        /// 掲載終了までの残り日数
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
        /// TODO:現在は仮値。通信処理が完成したら修正
        let appearDaysLeft: Int = 1

        if isFromSubscribeList {
            let string = NSAttributedString(string: "求人詳細はこちら", attributes: attributeNormalBlack as [String: Any])
            appearDaysLeftString.append(string)
        } else {
            /// TODO:AttributedStringはバイトルのEXTENSIONを使う
            if appearDaysLeft >= 4, appearDaysLeft <= 7 {
                let stringFirst = NSAttributedString(string: "掲載終了日まで残り ", attributes: attributeNormalBlack as [String: Any])
                let stringSecond = NSAttributedString(string: appearDaysLeft.description, attributes: attributeBoldBlack as [String: Any])
                let stringThird = NSAttributedString(string: " 日", attributes: attributeBoldBlack as [String: Any])

                appearDaysLeftString.append(stringFirst)
                appearDaysLeftString.append(stringSecond)
                appearDaysLeftString.append(stringThird)

            } else if appearDaysLeft >= 1, appearDaysLeft <= 3 {
                let stringFirst = NSAttributedString(string: "掲載終了日まで残り ", attributes: attributeNormalBlack as [String: Any])
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
    }

    /// コレクションのセル数を返却
    ///
    /// - Returns: Int
    func numberOfCollectionCellAtSection() -> Int {
        return benefitIconArray.count
    }

    /// コレクションセルの文字列を返却
    ///
    /// - Parameter indexPath: IndexPath
    /// - Returns: String
    func collectionCellText(indexPath: IndexPath) -> String {
        return benefitIconArray[indexPath.row]
    }

}
