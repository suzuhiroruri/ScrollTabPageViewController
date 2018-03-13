//
//  BAView.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/03/13.
//  Copyright © 2018年 EndouMari. All rights reserved.
//

import UIKit

extension BAView: BAScoutDetailJobBaseViewControllerProtocol {
    var scrollView: UIScrollView {
        guard let scrollView = mailScrollView else {
            return UIScrollView()
        }
        return scrollView
    }
}

class BAView: UIView {
    @IBOutlet weak var mailScrollView: UIScrollView!
    var scrollDelegateFunc: ((UIScrollView) -> Void)?

    // 応募日時土台ビュー
    @IBOutlet weak var subscribeDateBaseView: UIView!
    // 応募日時ラベル
    @IBOutlet weak var subscribeDateLabel: UILabel!
    // 表示期限ラベル
    @IBOutlet weak var displayLimitDateLabel: UILabel!

    // スカウトメール受信日のラベル
    @IBOutlet weak var receivedDateLabel: UILabel!
    // スカウトメールヘッダータイトルのラベル
    @IBOutlet weak var mailHeaderLabel: UILabel!
    var scoutDetailMailViewModel: BAScoutDetailMailViewModel?

    static func instantiate() -> BAView {
        let nib = UINib(nibName: R.nib.bAView.name, bundle: nil)

        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? BAView else {
            return BAView()
        }

        view.setViewContent()

        // ビューのサイズを調整
        view.sizeFitting()
        return view
    }
    private func setViewContent() {
        mailScrollView.delegate = self
        scoutDetailMailViewModel = BAScoutDetailMailViewModel.init()

        guard let isFromSubscribeList = scoutDetailMailViewModel?.isFromSubscribeList else {
            return
        }

        // スカウトメール受信日ラベル
        receivedDateLabel.textColor = isFromSubscribeList ? UIColor.red : UIColor.black
        receivedDateLabel.text = scoutDetailMailViewModel?.receivedDate

        // スカウトメールヘッダーラベル
        mailHeaderLabel.text = scoutDetailMailViewModel?.mailHeader
        mailHeaderLabel.sizeToFit()
    }
    // ビューのサイズを調整
    private func sizeFitting() {
        // 重要：xibと実機のwidthが違うと、systemLayoutSizeFittingが正しく計測されないため事前にwidthを合わせる。
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height)

        self.setNeedsLayout()
        self.layoutIfNeeded()

        let size = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: size.height)
        print("\n",
              "size.height",
              "\n",
              size.height
        )
    }
}

extension BAView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ mailScrollView: UIScrollView) {
        if self.scrollDelegateFunc != nil {
            guard let scrollDelegateFunc = self.scrollDelegateFunc else {
                return
            }
            scrollDelegateFunc(mailScrollView)
        }
    }
}
