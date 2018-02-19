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

    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    // 特典アイコンの土台ビュー
    @IBOutlet weak var benefitCollectionBaseView: UIView!
    // 特典アイコンのcollectionView
    @IBOutlet weak var benefitCollectionView: UICollectionView! {
        didSet {
            let nib = UINib(nibName: R.nib.bAScoutDetailBenefitCollectionCell.name, bundle: nil)
            benefitCollectionView.register(nib, forCellWithReuseIdentifier: "bAScoutDetailBenefitCollectionCell")
        }
    }
    // スカウト特典備考の土台ビュー
    @IBOutlet weak var benefitRemarksBaseView: UIView!
    // スカウト特典備考ラベル
    @IBOutlet weak var benefitRemarksLabel: UILabel!

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
        mailHeaderLabel.text = "彼らはほかことに同じ経験人についてののうちを"
        mailHeaderLabel.sizeToFit()

        guard let benefitRemarksIsEmpty = scoutDetailMailViewModel?.benefitRemarks?.isEmpty else {
            return
        }
        if benefitRemarksIsEmpty {
            benefitRemarksBaseView.isHidden = true
        } else {
            benefitRemarksLabel.text = scoutDetailMailViewModel?.benefitRemarks
            benefitRemarksLabel.sizeToFit()
        }
        guard let promisedInterviewBenefitTitleIsEmpty: Bool = scoutDetailMailViewModel?.promisedInterviewBenefitTitle?.isEmpty else {
            return
        }
        /*
        if promisedInterviewBenefitTitleIsEmpty {
            promisedInterViewBenefitBaseView.isHidden = true
        } else {
            promisedInterviewBenefitSubTitleLabel.text = scoutDetailMailViewModel?.promisedInterviewBenefitSubTitle
            promisedInterviewBenefitTitleLabel.text = scoutDetailMailViewModel?.promisedInterviewBenefitTitle
        }
        */

    }

    private func sizeFitting() {

        // 重要：xibと実機のwidthが違うと、systemLayoutSizeFittingが正しく計測されないため事前にwidthを合わせる。
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height)

        self.setNeedsLayout()
        self.layoutIfNeeded()
        collectionHeight.constant = benefitCollectionView.contentSize.height
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
