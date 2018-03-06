//
//  BAScoutDetailJobBaseViewController.swift
//  Baitoru
//
//  Created by System on 2016/12/07.
//  Copyright © 2016年 DIP Coporation. All rights reserved.
//

import UIKit

protocol BAScoutDetailJobBaseViewControllerProtocol {
    var scoutDetailJobBaseViewController: BAScoutDetailJobBaseViewController { get }
    var scrollView: UIScrollView { get }
}

class BAScoutDetailJobBaseViewController: UIViewController {

    /// タブにセットするViewController
    var inTabViewController: [UIViewController] = []

    // pageViewControllerの更新index
    var updateIndex: Int = 0

    // スカウトメールのビュー
    var scoutDetailMailView: BAScoutDetailMailView!

    // スカウトメールのビューの高さ
    var mailViewHeight: CGFloat = 0.0
    var mailViewRealHeight: CGFloat = 0.0

    // スカウトメールのビューのスクロールの値
    var mailViewScrollContentOffsetY: CGFloat = 0.0

    var shouldScrollMailView: Bool = true

    // 仕事詳細ビューのスクロールをさせるべきかどうかを判別する変数
    var shouldUpdateJobDetailContentOffset: Bool = false

    // pageViewControllerの現在のindex
    var currentIndex: Int? {
        guard let pageViewController = pageViewController else {
            return nil
        }
        guard let viewController = pageViewController.viewControllers?.first, let index = inTabViewController.index(of: viewController) else {
            return nil
        }
        return index
    }

	/// 募集内容
    lazy var requirementsViewController: BAScoutDetailJobRequirementsViewController? = {
        let sb1 = UIStoryboard(name: R.storyboard.bAScoutDetailJobRequirementsViewController.name, bundle: nil)
        let vc1 = sb1.instantiateViewController(withIdentifier: "BAScoutDetailJobRequirementsViewController") as? BAScoutDetailJobRequirementsViewController
        return vc1
    }()

    /// 選考・会社概要
    lazy var selectionViewController: BAScoutDetailJobSelectionViewController? = {
        let sb2 = UIStoryboard(name: R.storyboard.bAScoutDetailJobSelectionViewController.name, bundle: nil)
        let vc2 = sb2.instantiateViewController(withIdentifier: "BAScoutDetailJobSelectionViewController") as? BAScoutDetailJobSelectionViewController
        return vc2
    }()

    /// タブ切り替え用
    lazy var pageViewController: UIPageViewController? = {
        if let pageViewController = self.childViewControllers.first as? UIPageViewController {
            pageViewController.delegate = self
            pageViewController.dataSource = self
            return pageViewController
        }
        return nil
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // View初期設定
        self.updateView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let currentIndex = self.currentIndex, let jobDetailViewController = self.inTabViewController[currentIndex] as? BAScoutDetailJobBaseViewControllerProtocol else {
            return
        }
        // 初期表示の時にスクロールの位置がずれてしまう場合、修正する
        if -jobDetailViewController.scrollView.contentOffset.y < scoutDetailMailView.frame.height {
            jobDetailViewController.scrollView.contentOffset.y = -scoutDetailMailView.frame.height
        }
    }
}

// MARK: - View

extension BAScoutDetailJobBaseViewController {
    /// 表示更新
    func updateView() {
        // スカウトメールのビューをセットアップ
        self.setupScoutDetailMailView()

        // タブ、ViewControllerセット
        self.setupJobDetailViewControllers()

        // pageViewControllerに仕事詳細のcontrollerをセットアップ
        self.setupPageViewController()
    }

    // scoutDetailMailViewのセットアップ
    func setupScoutDetailMailView() {
        // scoutMailViewを生成
        scoutDetailMailView = BAScoutDetailMailView.instantiate()
        let barHeight: CGFloat = 64
        mailViewHeight = scoutDetailMailView.frame.height - barHeight
        mailViewRealHeight = scoutDetailMailView.frame.height

        // タップでセグメントが変更された時の挙動を設定
        scoutDetailMailView.segmentChangedBlock = { [weak self] (index: Int) in
            self?.shouldUpdateJobDetailContentOffset = true
            self?.updateIndex = index
            guard let currentIndex = self?.currentIndex else {
                return
            }
            let direction: UIPageViewControllerNavigationDirection = (currentIndex < index) ? .forward : .reverse
            guard let inTabViewController = self?.inTabViewController else {
                return
            }
            if let pageViewController = self?.pageViewController {
                pageViewController.setViewControllers([inTabViewController[index]],
                                         direction: direction,
                                         animated: false,
                                         completion: { [weak self] (completed: Bool) in
                                            guard let shouldUpdateLayout = self?.shouldUpdateJobDetailContentOffset else {
                                                return
                                            }
                                            if shouldUpdateLayout {
                                                guard let mailViewScrollContentOffsetY = self?.mailViewScrollContentOffsetY else {
                                                    return
                                                }
                                                // jobDetailのテーブルのスクロールのY座標をセット
                                                self?.setupJobDetailScrollContentOffsetY(index: index, mailViewScrollContentOffsetY: -mailViewScrollContentOffsetY)
                                                self?.shouldUpdateJobDetailContentOffset = false
                                            }
                })
            }
        }

        // scoutDetailMailViewのDidScrollの時のブロック
        scoutDetailMailView.mailScrollDidChangedBlock = { [weak self] (scroll: CGFloat, shouldScrollMailView: Bool) in
            guard let currentIndex = self?.currentIndex, let jobDetailViewController = self?.inTabViewController[currentIndex] as? BAScoutDetailJobBaseViewControllerProtocol else {
                return
            }
            jobDetailViewController.scrollView.isUserInteractionEnabled = false
            self?.shouldScrollMailView = shouldScrollMailView
            // 仕事詳細のテーブルのスクロールのY座標を更新する
            self?.updateJobDetailTableContentOffsetY(scroll: scroll)
            jobDetailViewController.scrollView.isUserInteractionEnabled = true
        }

        // scoutDetailMailViewのDidEndDeceleratingの時のブロック
        // jobDetailTableのスクロールがずれたときの補正を行う
        scoutDetailMailView.mailScrollDidEndDeceleratingBlock = { [weak self] (mailScrollContentOffset: CGFloat, frameMinY: CGFloat) in

            guard let width = self?.scoutDetailMailView.frame.width, let height = self?.scoutDetailMailView.frame.height else {
                return
            }

            if frameMinY > 0.0 {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                        self?.scoutDetailMailView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                    }, completion: nil)
                }
            }

            if mailScrollContentOffset <= 0.0 && frameMinY >= 0.0 {
                self?.updateJobDetailViewFrame()
            }
        }
        view.addSubview(scoutDetailMailView)
    }

    /// タブ、ViewControllerをセットする
    func setupJobDetailViewControllers() {
        // 案件情報に動画、雰囲気に関する情報がない場合は雰囲気タブは表示しない
        if let viewController = requirementsViewController {
            inTabViewController.append(viewController)
        }
        if let viewController = selectionViewController {
            inTabViewController.append(viewController)
        }
    }

    // pageViewControllerをセットアップする
    func setupPageViewController() {
        if let pageViewController = pageViewController {
            // viewControllerをセット
            // セグメントを変更した時のアニメーションガタつき対策のため、あらかじめ両方セットしておく
            pageViewController.setViewControllers([inTabViewController[1]],
                               direction: .forward,
                               animated: false,
                               completion: { [weak self] (completed: Bool) in
                                // 現在のBAScoutDetailJobViewControllerのscrollView(tableView)の上部のマージンをセット
                                self?.setupJobDetailScrollContentInset(index: 1)
            })
            pageViewController.setViewControllers([inTabViewController[0]],
                               direction: .forward,
                               animated: false,
                               completion: { [weak self] (completed: Bool) in
                                // 現在のBAScoutDetailJobViewControllerのscrollView(tableView)の上部のマージンをセット
                                self?.setupJobDetailScrollContentInset(index: 0)
            })
        }
    }
}

// MARK: - updateScroll
extension BAScoutDetailJobBaseViewController {
    /**
     BAScoutDetailJobViewControllerのscrollView(tableView)の上部のマージンをセット
     */
    func setupJobDetailScrollContentInset(index: Int) {
        guard let jobDetailViewController = inTabViewController[index] as? BAScoutDetailJobBaseViewControllerProtocol else {
            return
        }

        jobDetailViewController.scrollView.contentInset.top = mailViewRealHeight
        jobDetailViewController.scrollView.scrollIndicatorInsets.top = mailViewRealHeight
    }

    /**
     ページングがされ、mailViewがまだ表示されているとき、jobDetailのテーブルのスクロールのオフセットを設定
     - parameter index: ページングのindex
     - parameter scroll: どれだけスクロールしているか
     */
    func setupJobDetailScrollContentOffsetY(index: Int, mailViewScrollContentOffsetY: CGFloat) {
        guard let  jobDetailViewController = inTabViewController[index] as? BAScoutDetailJobBaseViewControllerProtocol else {
            return
        }

        if mailViewScrollContentOffsetY == 0.0 {
            // 全くスクロールしていないときはmailViewの高さをそのままjobDetailViewのOffsetに設定
            jobDetailViewController.scrollView.contentOffset.y = -mailViewHeight
        } else if mailViewScrollContentOffsetY < (mailViewHeight - scoutDetailMailView.segmentedControlHeight.constant) ||
            jobDetailViewController.scrollView.contentOffset.y <= -scoutDetailMailView.segmentedControlHeight.constant {
            // スクロールされているがmailViewが表示されている場合は、スクロール分からmailViewの高さを差し引いた分をoffsetとする
            jobDetailViewController.scrollView.contentOffset.y = mailViewScrollContentOffsetY - mailViewHeight
        }
    }

    /**
     jobDetailのスクロールをmailViewに反映
     - parameter scroll: 移動した分の座標
     */
    func updateMailView(scroll: CGFloat) {
        if shouldScrollMailView, scroll != 0 {
            scoutDetailMailView.frame.origin.y = scroll
            mailViewScrollContentOffsetY = scroll
        }
        shouldScrollMailView = true
    }

    /**
     jobDetailのテーブルのスクロールのY座標を更新
     - parameter scroll: 移動した分の座標
     */
    func updateJobDetailTableContentOffsetY(scroll: CGFloat) {
        if let currentIndex = currentIndex, let jobDetailViewController = inTabViewController[currentIndex] as? BAScoutDetailJobBaseViewControllerProtocol {
            // jobDetailのテーブルのスクロールのY座標を更新を反映させている間、userInteractionを許可しないことにより、意図しないスクロールのずれを防ぐ
            jobDetailViewController.scrollView.isUserInteractionEnabled = false
            jobDetailViewController.scrollView.contentOffset.y += scroll
            jobDetailViewController.scrollView.isUserInteractionEnabled = true
        }
    }

    // jobDetailTableのスクロールがずれたときの補正を行う
    func updateJobDetailViewFrame() {
        guard let currentIndex = currentIndex, let jobDetailViewController = inTabViewController[currentIndex] as? BAScoutDetailJobBaseViewControllerProtocol else {
            return
        }
        if jobDetailViewController.scrollView.isDragging == false {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                    jobDetailViewController.scrollView.contentOffset.y = -self.scoutDetailMailView.scrollView.frame.height
                }, completion: nil)
            }
        }
    }

    /**
     メールとJobDetailのスクロールを更新
     */
    func updateContentViewFrame() {
        guard let currentIndex = currentIndex, let jobDetailViewController = inTabViewController[currentIndex] as? BAScoutDetailJobBaseViewControllerProtocol else {
            return
        }

        // jobDetailのscrollのオフセットがsegmentの高さより大きい場合
        if jobDetailViewController.scrollView.contentOffset.y >= -scoutDetailMailView.segmentedControlHeight.constant {
            // scoutDetailJobViewControllerのtableViewのスクロール更新
            let scroll = mailViewHeight - scoutDetailMailView.segmentedControlHeight.constant
            // mailViewのスクロールを更新
            self.updateMailView(scroll: -scroll)
            // jobDetailのscrollの上部の余白はsegmentの高さ
            jobDetailViewController.scrollView.scrollIndicatorInsets.top = scoutDetailMailView.segmentedControlHeight.constant
        } else {
            // scoutDetailMailViewとscoutDetailJobViewControllerのtableViewのスクロール更新
            let scroll = mailViewHeight + jobDetailViewController.scrollView.contentOffset.y
            // mailViewのスクロールを更新
            self.updateMailView(scroll: -scroll)
            // jobDetailのscrollの上部の余白はjobDetailのcontentOffset(=mailViewの表示の高さ)
            jobDetailViewController.scrollView.scrollIndicatorInsets.top = -jobDetailViewController.scrollView.contentOffset.y
        }
    }

    /**
     JobDetailの余白とY座標を更新(主にページャーが更新されたとき)
     */
    func updateJobDetailLayoutIfNeeded() {
        if shouldUpdateJobDetailContentOffset {
            let jobDetailViewController = inTabViewController[updateIndex] as? BAScoutDetailJobBaseViewControllerProtocol
            let shouldSetupContentOffsetY = jobDetailViewController?.scrollView.contentInset.top != mailViewHeight

            guard let currentIndex = currentIndex else {
                return
            }

            // 現在のBAScoutDetailJobViewControllerのscrollView(tableView)の上部のマージンをセット
            self.setupJobDetailScrollContentInset(index: currentIndex)
            // jobDetailのテーブルのスクロールのY座標をセット
            self.setupJobDetailScrollContentOffsetY(index: updateIndex, mailViewScrollContentOffsetY: -mailViewScrollContentOffsetY)
            shouldUpdateJobDetailContentOffset = shouldSetupContentOffsetY
        }
    }
}

// MARK: - UIPageViewControllerDateSource

extension BAScoutDetailJobBaseViewController: UIPageViewControllerDataSource {

    /**
     1つ目のviewControllerに戻った時の処理
     - parameter pageViewController: pageViewController
     - parameter viewController: 現在表示されている2つ目のviewController
     - returns: 1つ目に戻った時に表示されるviewController
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard var index = inTabViewController.index(of: viewController) else {
            return nil
        }

        index -= 1

        if index >= 0 && index < inTabViewController.count {
            return inTabViewController[index]
        }
        return nil
    }

    /**
     2つ目のviewControllerに進んだ時の処理
     - parameter pageViewController: pageViewController
     - parameter viewController: 現在表示されている1つ目のviewController
     - returns: 2つ目に進んだ時に表示されるviewController
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard var index = inTabViewController.index(of: viewController) else {
            return nil
        }

        index += 1

        if index >= 0 && index < inTabViewController.count {
            return inTabViewController[index]
        }
        return nil
    }
}

// MARK: - UIPageViewControllerDelegate
extension BAScoutDetailJobBaseViewController: UIPageViewControllerDelegate {

    /**
     スワイプでpageViewControllerで別のviewControllerに遷移する時の処理
     - parameter pageViewController: pageViewController
     - parameter pagingViewControllers: これから遷移しようとしているviewController
     */
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let viewController = pendingViewControllers.first, let index = inTabViewController.index(of: viewController) {

            shouldUpdateJobDetailContentOffset = true
            updateIndex = index
            // 次のBAScoutDetailJobViewControllerのscrollView(tableView)の上部のマージンをセット
            self.setupJobDetailScrollContentInset(index: updateIndex)
        }
    }

    /**
     スワイプのpageViewControllerのアニメーションが終わった時の処理
     - parameter pageViewController: pageViewController
     - parameter fisnished: アニメーション完了のBOOL値
     - parameter previousViewControllers: 遷移前のviewController
     - parameter completed: 遷移完了のBOOL値
     */
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let _ = previousViewControllers.first, let currentIndex = currentIndex else {
            return
        }

        if shouldUpdateJobDetailContentOffset {
            // 現在のBAScoutDetailJobViewControllerのscrollView(tableView)の上部のマージンをセット
            self.setupJobDetailScrollContentInset(index: currentIndex)

            // jobDetailのテーブルのスクロールのY座標をセット
            self.setupJobDetailScrollContentOffsetY(index: currentIndex, mailViewScrollContentOffsetY: -mailViewScrollContentOffsetY)
        }

        if currentIndex >= 0 && currentIndex < scoutDetailMailView.segmentedControl.numberOfSegments {
            scoutDetailMailView.updateCurrentIndex(index: currentIndex, animated: false)
        }
    }
}
