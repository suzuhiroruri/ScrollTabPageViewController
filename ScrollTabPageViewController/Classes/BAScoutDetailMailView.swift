//
//  CardView.swift
//  AutoSizingLabelSample
//
//  Created by Shota Kashihara on 2017/07/28.
//  Copyright © 2017年 Shota Kashihara. All rights reserved.
//

import UIKit

protocol BAScoutDetailMailViewProtocol {
    func showAboutBenefitView()
}

class BAScoutDetailMailView: UIView {

    var bAScoutDetailMailViewProtocol: BAScoutDetailMailViewProtocol?

    // スクロールビュー
    @IBOutlet weak var scrollView: UIScrollView!
    // スクロール開始時点の初期値
    var scrollStart: CGFloat = 0.0
    // スクロール検知のブロック
    var mailScrollDidChangedBlock: ((_ scroll: CGFloat, _ shouldMailView: Bool) -> Void)?
    // スクロール慣性終了検知のブロック
    var mailScrollDidEndDeceleratingBlock: ((_ mailScrollContentOffset: CGFloat, _ frameMinY: CGFloat) -> Void)?

    // スカウトメール受信日のラベル
    @IBOutlet weak var receivedDateLabel: UILabel!
    // スカウトメールヘッダータイトルのラベル
    @IBOutlet weak var mailHeaderLabel: UILabel!

    @IBOutlet weak var interViewBenefitBaseView: UIView!
    // 面接確約特典のサブタイトル
    @IBOutlet weak var promisedInterviewBenefitSubTitleLabel: UILabel!
    // 面接確約特典のタイトル
    @IBOutlet weak var promisedInterviewBenefitTitleLabel: UILabel!
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

    // スカウトメール本文
    @IBOutlet weak var mailBodyLabel: UILabel!

    // セグメントビュー
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    // セグメントビューの高さ
    @IBOutlet weak var segmentedControlHeight: NSLayoutConstraint!
    // 選択されているsegmentのindex
    var currentIndex: Int = 0
    // セグメントが変更されたときの処理
    var segmentChangedBlock: ((_ index: Int) -> Void)?

    var scoutDetailMailViewModel: BAScoutDetailMailViewModel?

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
        scoutDetailMailViewModel = BAScoutDetailMailViewModel.init()
        scrollView.delegate = self

        benefitCollectionView.delegate = self
        benefitCollectionView.dataSource = self

        guard let isFromSubscribeList = scoutDetailMailViewModel?.isFromSubscribeList else {
            return
        }
        receivedDateLabel.textColor = isFromSubscribeList ? UIColor.red : UIColor.black
        receivedDateLabel.text = scoutDetailMailViewModel?.receivedDate

        mailHeaderLabel.text = scoutDetailMailViewModel?.mailHeader
        mailHeaderLabel.sizeToFit()

        guard let promisedInterviewBenefitTitleIsEmpty: Bool = scoutDetailMailViewModel?.promisedInterviewBenefitTitle?.isEmpty else {
            return
        }
        if promisedInterviewBenefitTitleIsEmpty {
            interViewBenefitBaseView.isHidden = true
        } else {
            promisedInterviewBenefitSubTitleLabel.text = scoutDetailMailViewModel?.promisedInterviewBenefitSubTitle
            promisedInterviewBenefitTitleLabel.text = scoutDetailMailViewModel?.promisedInterviewBenefitTitle
        }

        guard let benefitRemarksIsEmpty = scoutDetailMailViewModel?.benefitRemarks?.isEmpty else {
            return
        }
        if benefitRemarksIsEmpty {
            benefitRemarksBaseView.isHidden = true
        } else {
            benefitRemarksLabel.text = scoutDetailMailViewModel?.benefitRemarks
            benefitRemarksLabel.sizeToFit()
        }

        mailBodyLabel.text = scoutDetailMailViewModel?.mailBody
        mailBodyLabel.sizeToFit()
    }

    private func sizeFitting() {
        scrollView.delegate = self

        // 重要：xibと実機のwidthが違うと、systemLayoutSizeFittingが正しく計測されないため事前にwidthを合わせる。
        self.frame = CGRect.init(x: 0, y: 64.0, width: UIScreen.main.bounds.width, height: self.frame.height)

        self.setNeedsLayout()
        self.layoutIfNeeded()

        collectionHeight.constant = benefitCollectionView.contentSize.height

        let size = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        self.frame = CGRect.init(x: 0, y: 64.0, width: UIScreen.main.bounds.width, height: size.height)
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

    /**
     スカウト特典についてのボタンをタップしたときの処理
     - parameter sender: UIButton
     */
    @IBAction func tapAboutScoutbenefitLink(_ sender: UIButton) {
        bAScoutDetailMailViewProtocol?.showAboutBenefitView()
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
