//
//  CardView.swift
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

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!

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
        self.contentLabel.text = "赤（あか、紅、朱、丹）は色のひとつで、熟したイチゴや血液のような色の総称。JIS規格では基本色名の一つ。国際照明委員会 (CIE) は700 nm の波長をRGB表色系においてR（赤）と規定している。赤より波長の長い光を赤外線と呼ぶが、様々な表色系など赤（あか、紅、朱、丹）は色のひとつで、熟したイチゴや血液のような色の総称。JIS規格では基本色名の一つ。国際照明委員会 (CIE) は700 nm の波長をRGB表色系においてR（赤）と規定している。赤より波長の長い光を赤外線と呼ぶが、様々な表色系など赤（あか、紅、朱、丹）は色のひとつで、熟したイチゴや血液のような色の総称。JIS規格では基本色名の一つ。国際照明委員会 (CIE) は700 nm の波長をRGB表色系においてR（赤）と規定している。赤より波長の長い光を赤外線と呼ぶが、様々な表色系など赤（あか、紅、朱、丹）は色のひとつで、熟したイチゴや血液のような色の総称。JIS規格では基本色名の一つ。国際照明委員会 (CIE) は700 nm の波長を"
    }

    private func sizeFitting() {
        scrollView.delegate = self

        // 重要：xibと実機のwidthが違うと、systemLayoutSizeFittingが正しく計測されないため事前にwidthを合わせる。
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height)

        self.setNeedsLayout()
        self.layoutIfNeeded()
        let size = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        self.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
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
