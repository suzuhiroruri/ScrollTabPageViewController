//
//  BAScoutDetailMailView.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/03/13.
//  Copyright © 2018年 hir-suzuki. All rights reserved.
//

import UIKit

class BAScoutDetailMailView: UIView {

    /// スクロールビュー
    @IBOutlet weak var mailScrollView: UIScrollView!
    var scrollDelegateFunc: ((UIScrollView) -> Void)?

    /// 応募日時土台ビュー
    @IBOutlet weak var subscribeDateBaseView: UIView!
    /// 応募日時ラベル
    @IBOutlet weak var subscribeDateLabel: UILabel!
    /// 表示期限ラベル
    @IBOutlet weak var displayLimitDateLabel: UILabel!

    /// スカウトメール受信日の土台ビュー
    @IBOutlet weak var receivedDateBaseView: UIView!
    @IBOutlet weak var receivedDataBaseViewConstant: NSLayoutConstraint!
    /// スカウトメール受信日のラベル
    @IBOutlet weak var receivedDateLabel: UILabel!
    /// スカウトメールヘッダータイトルのラベル
    @IBOutlet weak var mailHeaderLabel: UILabel!

    /// 面接確約特典タイトルの土台ビュー
    @IBOutlet weak var promisedInterViewBenefitBaseView: UIView!
    /// 面接確約特典のタイトルラベル
    @IBOutlet weak var promisedInterviewBenefitTitleLabel: UILabel!

    /// 特典アイコンの土台ビュー
    @IBOutlet weak var benefitCollectionBaseView: UIView!
    /// 特典アイコンのcollectionView
    @IBOutlet weak var benefitCollectionView: UICollectionView! {
        didSet {
            benefitCollectionView.register(R.nib.bAScoutDetailBenefitCollectionCell)
        }
    }
    /// 特典アイコンのcollectionViewの上部制約
    @IBOutlet weak var benefitCollectionTopConstrant: NSLayoutConstraint!
    /// 特典アイコンのcollectionViewの下部制約
    @IBOutlet weak var benefitCollectionBottomConstrant: NSLayoutConstraint!
    /// 特典アイコンのcollectionViewの高さ
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!

    /// スカウト特典備考の土台ビュー
    @IBOutlet weak var benefitRemarksBaseView: UIView!
    /// スカウト特典備考ラベル
    @IBOutlet weak var benefitRemarksLabel: UILabel!

    // スカウトメール本文ラベル
    @IBOutlet weak var mailBodyLabel: UILabel!

    /// 掲載終了残り日数土台ビュー
    @IBOutlet weak var appearDaysLeftBaseView: UIView!
    /// 掲載終了残り日数ラベル
    @IBOutlet weak var appearDaysLeftLabel: UILabel!
    /// 掲載終了残り日数ラベルの高さ
    @IBOutlet weak var appearDaysLeftLabelHeight: NSLayoutConstraint!

    fileprivate let scoutDetailMailViewModel: BAScoutDetailMailViewModel = BAScoutDetailMailViewModel()

    /// ビューを生成する
    ///
    /// - Returns: BAScoutDetailMailView
    static func instantiate() -> BAScoutDetailMailView {
        let nib = UINib(nibName: R.nib.bAScoutDetailMailView.name, bundle: nil)

        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? BAScoutDetailMailView else {
            return BAScoutDetailMailView()
        }
        view.setViewContent()
        /// ビューのサイズを調整
        view.sizeFitting()
        return view
    }

    private func setViewContent() {
        mailScrollView.delegate = self
        benefitCollectionView.delegate = self
        benefitCollectionView.dataSource = self

        scoutDetailMailViewModel.updateMailData()

        if scoutDetailMailViewModel.isFromSubscribeList {
            /// 応募済みの場合
            subscribeDateLabel.isHidden = false
            receivedDateBaseView.isHidden = false
            receivedDateLabel.isHidden = false
            subscribeDateLabel.text = scoutDetailMailViewModel.subscribeDate
            /// 表示期限
            displayLimitDateLabel.textColor = UIColor.gray
        } else {
            // 未応募の場合
            subscribeDateLabel.isHidden = true
            receivedDateBaseView.isHidden = true
            receivedDateLabel.isHidden = true
            receivedDataBaseViewConstant.constant = 0

            /// 表示期限
            displayLimitDateLabel.textColor = UIColor.black
        }
        /// 表示期限
        displayLimitDateLabel.text = scoutDetailMailViewModel.displayLimitDate

        /// スカウトメール受信日ラベル
        receivedDateLabel.text = scoutDetailMailViewModel.receivedDate

        /// スカウトメールヘッダーラベル
        mailHeaderLabel.text = scoutDetailMailViewModel.mailHeader
        mailHeaderLabel.sizeToFit()

        /// 面接確約特典ラベル
        if scoutDetailMailViewModel.promisedInterviewBenefitTitle.isEmpty {
            promisedInterViewBenefitBaseView.isHidden = true
        } else {
            promisedInterviewBenefitTitleLabel.text = scoutDetailMailViewModel.promisedInterviewBenefitTitle
        }

        /// スカウト特典備考ラベル
        guard let benefitRemarksIsEmpty = scoutDetailMailViewModel.benefitRemarks?.isEmpty else {
            return
        }
        if benefitRemarksIsEmpty {
            benefitRemarksBaseView.isHidden = true
        } else {
            benefitRemarksLabel.text = scoutDetailMailViewModel.benefitRemarks
            benefitRemarksLabel.sizeToFit()
        }

        /// スカウトメール本文ラベル
        mailBodyLabel.text = scoutDetailMailViewModel.mailBody
        mailBodyLabel.sizeToFit()

        /// 掲載終了残り日数ラベル
        appearDaysLeftLabel.attributedText = scoutDetailMailViewModel.appearDaysLeftString
        guard let isAppearDaysLeftLabelEmpty = appearDaysLeftLabel.text?.isEmpty else {
            return
        }
        if isAppearDaysLeftLabelEmpty {
            appearDaysLeftLabelHeight.constant = 0
            appearDaysLeftLabel.isHidden = true
            appearDaysLeftBaseView.isHidden = true
        }
    }

    /// ビューのサイズを調整
    private func sizeFitting() {
        /// 重要：xibと実機のwidthが違うと、systemLayoutSizeFittingが正しく計測されないため事前にwidthを合わせる。
        frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: frame.height)

        setNeedsLayout()
        layoutIfNeeded()

        /// 特典アイコンのcollectionViewの高さを調整
        collectionHeight.constant = benefitCollectionView.contentSize.height

        let size = systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: size.height)
    }
}

extension BAScoutDetailMailView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ mailScrollView: UIScrollView) {
        if scrollDelegateFunc != nil {
            guard let scrollDelegateFunc = scrollDelegateFunc else {
                return
            }
            scrollDelegateFunc(mailScrollView)
        }
    }
}

extension BAScoutDetailMailView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /// MARK: - CollectionView Delegate & DataSource

    /// TODO:collectionの内容に関しては、別途通信処理が整い次第修正

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if scoutDetailMailViewModel.numberOfCollectionCellAtSection() <= 0 {
            benefitCollectionBaseView.isHidden = true
            benefitCollectionTopConstrant.constant = 0
            benefitCollectionBottomConstrant.constant = 0
        }
        return scoutDetailMailViewModel.numberOfCollectionCellAtSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = benefitCollectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.bAScoutDetailBenefitCollectionCell.identifier, for: indexPath) as? BAScoutDetailBenefitCollectionCell else {
            return UICollectionViewCell()
        }
        cell.label.text = scoutDetailMailViewModel.collectionCellText(indexPath: indexPath)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 25)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}

extension BAScoutDetailMailView: BAScoutDetailJobBaseViewControllerProtocol {
    var scrollView: UIScrollView {
        guard let scrollView = mailScrollView else {
            return UIScrollView()
        }
        return scrollView
    }
}
