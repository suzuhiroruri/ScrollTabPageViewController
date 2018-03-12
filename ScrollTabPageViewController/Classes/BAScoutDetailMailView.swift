//
//  BAScoutDetailMailView.swift
//  AutoSizingLabelSample
//
//  Created by Hiromasa Suzuki on 2017/07/28.
//  Copyright © 2018年 Hiromasa Suzuki All rights reserved.
//

import UIKit

class BAScoutDetailMailView: UIView {

    // スクロールビュー
    @IBOutlet weak var mailScrollView: UIScrollView!

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

    // 面接確約特典タイトルの土台ビュー
    @IBOutlet weak var promisedInterViewBenefitBaseView: UIView!
    // 面接確約特典のサブタイトルラベル
    @IBOutlet weak var promisedInterviewBenefitSubTitleLabel: UILabel!
    // 面接確約特典のタイトルラベル
    @IBOutlet weak var promisedInterviewBenefitTitleLabel: UILabel!

    // 特典アイコンの土台ビュー
    @IBOutlet weak var benefitCollectionBaseView: UIView!
    // 特典アイコンのcollectionView
    @IBOutlet weak var benefitCollectionView: UICollectionView! {
        didSet {
            let nib = UINib(nibName: R.nib.bAScoutDetailBenefitCollectionCell.name, bundle: nil)
            benefitCollectionView.register(nib, forCellWithReuseIdentifier: "bAScoutDetailBenefitCollectionCell")
        }
    }
    // 特典アイコンのcollectionViewの高さ
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!

    // スカウト特典備考の土台ビュー
    @IBOutlet weak var benefitRemarksBaseView: UIView!
    // スカウト特典備考ラベル
    @IBOutlet weak var benefitRemarksLabel: UILabel!

    // スカウトメール本文ラベル
    @IBOutlet weak var mailBodyLabel: UILabel!

    // 掲載終了残り日数土台ビュー
    @IBOutlet weak var appearDaysLeftBaseView: UIView!
    // 掲載終了残り日数ラベル
    @IBOutlet weak var appearDaysLeftLabel: UILabel!
    // 選択されているsegmentのindex
    var currentIndex: Int = 0

    var scoutDetailMailViewModel: BAScoutDetailMailViewModel?

    /**
     ビューを生成する
     - returns: BAScoutDetailMailView
     */
    static func instantiate() -> BAScoutDetailMailView {
        let nib = UINib(nibName: R.nib.bAScoutDetailMailView.name, bundle: nil)

        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? BAScoutDetailMailView else {
            return BAScoutDetailMailView()
        }
        view.setViewContent()
        // ビューのサイズを調整
        view.sizeFitting()
        return view
    }

    private func setViewContent() {
        scoutDetailMailViewModel = BAScoutDetailMailViewModel.init()
        mailScrollView.delegate = self

        benefitCollectionView.delegate = self
        benefitCollectionView.dataSource = self

        guard let isFromSubscribeList = scoutDetailMailViewModel?.isFromSubscribeList else {
            return
        }

        // スカウトメール受信日ラベル
        receivedDateLabel.textColor = isFromSubscribeList ? UIColor.red : UIColor.black
        receivedDateLabel.text = scoutDetailMailViewModel?.receivedDate

        // スカウトメールヘッダーラベル
        mailHeaderLabel.text = scoutDetailMailViewModel?.mailHeader
        mailHeaderLabel.sizeToFit()

        // 面接確約特典ラベル
        guard let promisedInterviewBenefitTitleIsEmpty: Bool = scoutDetailMailViewModel?.promisedInterviewBenefitTitle?.isEmpty else {
            return
        }
        if promisedInterviewBenefitTitleIsEmpty {
            promisedInterViewBenefitBaseView.isHidden = true
        } else {
            promisedInterviewBenefitSubTitleLabel.text = scoutDetailMailViewModel?.promisedInterviewBenefitSubTitle
            promisedInterviewBenefitTitleLabel.text = scoutDetailMailViewModel?.promisedInterviewBenefitTitle
        }

        // スカウト特典備考ラベル
        guard let benefitRemarksIsEmpty = scoutDetailMailViewModel?.benefitRemarks?.isEmpty else {
            return
        }
        if benefitRemarksIsEmpty {
            benefitRemarksBaseView.isHidden = true
        } else {
            benefitRemarksLabel.text = scoutDetailMailViewModel?.benefitRemarks
            benefitRemarksLabel.sizeToFit()
        }

        // スカウトメール本文ラベル
        mailBodyLabel.text = scoutDetailMailViewModel?.mailBody
        mailBodyLabel.sizeToFit()

        // 掲載終了残り日数ラベル
        appearDaysLeftLabel.attributedText = scoutDetailMailViewModel?.appearDaysLeftString
    }

    // ビューのサイズを調整
    private func sizeFitting() {
        // 重要：xibと実機のwidthが違うと、systemLayoutSizeFittingが正しく計測されないため事前にwidthを合わせる。
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height)

        self.setNeedsLayout()
        self.layoutIfNeeded()

        // 特典アイコンのcollectionViewの高さを調整
        collectionHeight.constant = benefitCollectionView.contentSize.height

        let size = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: size.height)
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

extension BAScoutDetailMailView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - CollectionView Delegate & DataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let scoutDetailMailViewModel = scoutDetailMailViewModel else {
            return 0
        }
        if !(scoutDetailMailViewModel.numberOfCollectionCellAtSection() > 0) {
            benefitCollectionBaseView.isHidden = true
        }
        return scoutDetailMailViewModel.numberOfCollectionCellAtSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let scoutDetailMailViewModel = scoutDetailMailViewModel, let cell = benefitCollectionView.dequeueReusableCell(withReuseIdentifier: "bAScoutDetailBenefitCollectionCell", for: indexPath) as? BAScoutDetailBenefitCollectionCell else {
            return UICollectionViewCell()
        }
        cell.label.text = scoutDetailMailViewModel.collectionCellText(indexPath: indexPath)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 25)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
