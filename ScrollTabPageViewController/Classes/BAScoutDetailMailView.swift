//
//  BAScoutDetailMailView.swift
//  AutoSizingLabelSample
//
//  Created by Shota Kashihara on 2017/07/28.
//  Copyright © 2017年 Shota Kashihara. All rights reserved.
//

import UIKit

class BAScoutDetailMailView: UIView {

    // スクロールビュー
    @IBOutlet weak var scrollView: UIScrollView!

    // スクロール開始時点の初期値
    var scrollStart: CGFloat = 0.0
    // スクロール検知のブロック
    var mailScrollDidChangedBlock: ((_ scroll: CGFloat, _ shouldScrollMailView: Bool) -> Void)?
    // スクロール慣性終了検知のブロック
    var mailScrollDidEndDeceleratingBlock: ((_ mailScrollContentOffset: CGFloat, _ frameMinY: CGFloat) -> Void)?

    // スカウトメール受信日のラベル
    @IBOutlet weak var receivedDateLabel: UILabel!
    // スカウトメールヘッダータイトルのラベル
    @IBOutlet weak var mailHeaderLabel: UILabel!

    // セグメントビュー
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    // セグメントビューの高さ
    @IBOutlet weak var segmentedControlHeight: NSLayoutConstraint!
    // 選択されているsegmentのindex
    var currentIndex: Int = 0
    // セグメントが変更されたときの処理
    var segmentChangedBlock: ((_ index: Int) -> Void)?

    /**
     ビューを生成する
     - returns: BAScoutDetailMailView
     */
    static func instantiate() -> BAScoutDetailMailView {
        let nib = UINib(nibName: R.nib.bAScoutDetailMailView.name, bundle: nil)

        guard let view = nib.instantiate(withOwner: nil, options: nil)[0] as? BAScoutDetailMailView else {
            return BAScoutDetailMailView()
        }
        view.setViewContent()
        view.sizeFitting()
        return view
    }

	private func setViewContent() {
        mailHeaderLabel.text = "彼らはほかことに同じ経験人についてののうちをすれでで。いったい今を学習心は幾分その講演たますなどに投げ出しばいなとは修養しませないが、少しにはすれたんたませ。主義で聴かた事はもとより今日がけっしてたんませ。けっして大森さんの話重き少々尊敬の云いない詩この二つ私か発展をという皆発表だたでたいから、漠然たるたくさんは私か否一団を立たから、張さんの事に金力のそれにもうご附着と使えるから私人がご研究へ云っようにもちろんご努力をあろますでて、とうとうよほど講演に進まですてならですのにできなあっ。"
        mailHeaderLabel.sizeToFit()
    }

    private func sizeFitting() {
        scrollView.delegate = self

        // 重要：xibと実機のwidthが違うと、systemLayoutSizeFittingが正しく計測されないため事前にwidthを合わせる。
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height)

        self.setNeedsLayout()
        self.layoutIfNeeded()
        let size = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: size.height+64)
    }

    /**
     セグメントのindex番号を更新
     - parameter index: 更新しようとしているindex番号
     - parameter animated: アニメーションするかのBOOL
     */
    func updateCurrentIndex(index: Int, animated: Bool) {
        segmentedControl.selectedSegmentIndex = index
        currentIndex = index
    }

    /**
     セグメントが変更されたときの処理
     - parameter sender: UISegmentedControl
     */
    @IBAction func changeSegmentValue(_ sender: UISegmentedControl) {
        // セグメントが変更されたときの処理
        segmentChangedBlock?(sender.selectedSegmentIndex)
        updateCurrentIndex(index: sender.selectedSegmentIndex, animated: true)
    }
}

extension BAScoutDetailMailView: UIScrollViewDelegate {

    /**
     BAScoutDetailMailViewへの慣性スクロールの終了を検知
     - parameter scrollView: scrollView
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        mailScrollDidEndDeceleratingBlock?(scrollView.contentOffset.y, frame.minY)
    }

    /**
     BAScoutDetailMailViewへのスクロールを検知
     - parameter scrollView: scrollView
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.y > 0.0 {
            mailScrollDidChangedBlock?(scrollView.contentOffset.y, true)
            scrollView.contentOffset.y = 0.0
        } else if frame.minY < 0.0 {
            mailScrollDidChangedBlock?(scrollView.contentOffset.y, true)
            scrollView.contentOffset.y = 0.0
        } else {
            let scroll = scrollView.contentOffset.y - scrollStart
            mailScrollDidChangedBlock?(scroll, false)
            scrollStart = scrollView.contentOffset.y
        }
    }
}
