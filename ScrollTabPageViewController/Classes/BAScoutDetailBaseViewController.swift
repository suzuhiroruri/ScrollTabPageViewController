//
//  BAScoutDetailBaseViewController.swift
//  ScrollTabPageViewController
//
//  Created by EndouMari on 2015/12/04.
//  Copyright © 2015年 EndouMari. All rights reserved.
//

import UIKit

protocol BAScoutDetailBaseViewControllerProtocol {
    var scoutDetailBaseViewController: BAScoutDetailBaseViewController { get }
    var scrollView: UIScrollView { get }
}

class BAScoutDetailBaseViewController: UIPageViewController {

    var pageViewControllers: [UIViewController] = []

    // pageViewControllerの更新index
    var updateIndex: Int = 0

    // スカウトメールのビュー
    var scoutDetailMailView: BAScoutDetailMailView!

    // スカウトメールのビューの高さ
    var mailViewHeight: CGFloat = 0.0

    // スカウトメールのビューのスクロールの値
    var mailViewScrollContentOffsetY: CGFloat = 0.0

    var shouldScrollMailView: Bool = true

    // 仕事詳細ビューのスクロールをさせるべきかどうかを判別する変数
    var shouldUpdateJobDetailContentOffset: Bool = false
    let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height

    // pageViewControllerの現在のindex
    var currentIndex: Int? {
        guard let viewController = viewControllers?.first, let index = pageViewControllers.index(of: viewController) else {
            return nil
        }
        return index
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "スカウト詳細"

        // 各ビューを設定
        self.setupViews()
    }
}


// MARK: - View

extension BAScoutDetailBaseViewController {

    // 各Viewを設定
    func setupViews() {

        // 仕事詳細のcontrollerをセットアップ
        self.setupJobDetailViewControllers()

        // スカウトメールのビューをセットアップ
        self.setupScoutDetailMailView()

        // pageViewControllerに仕事詳細のcontrollerを格納
        self.setupPageViewController()
    }

    // BAScoutDetailJobViewControllerをセットアップ
    // 別々のviewControllerを設定する場合はvc1&2の読み込み内容を変更する
    func setupJobDetailViewControllers() {
        // viewContrroller
        let sb1 = UIStoryboard(name: "ViewController", bundle: nil)
        let vc1 = sb1.instantiateViewController(withIdentifier: "ViewController")

        // viewContrroller
        let sb2 = UIStoryboard(name: "ViewController", bundle: nil)
        let vc2 = sb2.instantiateViewController(withIdentifier: "ViewController")

        pageViewControllers = [vc1, vc2]
    }

    // scoutDetailMailViewのセットアップ
    func setupScoutDetailMailView() {
        // scoutMailViewを生成
        scoutDetailMailView = BAScoutDetailMailView.instantiate()
        let barHeight: CGFloat = 64
        mailViewHeight = scoutDetailMailView.frame.height - barHeight

        // タップでセグメントが変更された時の挙動を設定
        scoutDetailMailView.segmentChangedBlock = { [weak self] (index: Int) in
            guard let uself = self else {
                return
            }
            
            uself.shouldUpdateJobDetailContentOffset = true
            uself.updateIndex = index
            let direction: UIPageViewControllerNavigationDirection = (uself.currentIndex! < index) ? .forward : .reverse
            uself.setViewControllers([uself.pageViewControllers[index]],
                                     direction: direction,
                                     animated: false,
                                     completion: { [weak self] (completed: Bool) in
                                        guard let uself = self else {
                                            return
                                        }
                                        if uself.shouldUpdateJobDetailContentOffset {
                                            uself.setupJobDetailScrollContentOffsetY(index:index, mailViewScrollContentOffsetY: -uself.mailViewScrollContentOffsetY)
                                            uself.shouldUpdateJobDetailContentOffset = false
                                        }
            })
        }

        // scoutDetailMailViewのDidScrollの時のブロック
        scoutDetailMailView.mailScrollDidChangedBlock = { [weak self] (scroll: CGFloat, shouldScrollFrame: Bool) in
            self?.shouldScrollMailView = shouldScrollFrame
            // 仕事詳細のテーブルのスクロールのY座標を更新する
            self?.updateJobDetailTableContentOffsetY(scroll: scroll)
        }
        view.addSubview(scoutDetailMailView)
    }

    // pageViewControllerをセットアップする
    func setupPageViewController() {
        dataSource = self
        delegate = self

        // 初回表示のviewControllerをセット
        setViewControllers([pageViewControllers[0]],
            direction: .forward,
            animated: false,
            completion: { [weak self] (completed: Bool) in
                // 現在のBAScoutDetailJobViewControllerのscrollView(tableView)の上部のマージンをセット
                self?.setupJobDetailScrollContentInset(index: 0)
            })
    }
}

// MARK: - updateScroll

extension BAScoutDetailBaseViewController {

    /**
     BAScoutDetailJobViewControllerのscrollView(tableView)の上部のマージンをセット
     */
    func setupJobDetailScrollContentInset(index: Int) {
        guard let jobDetailViewController = pageViewControllers[index] as? BAScoutDetailBaseViewControllerProtocol else {
            return
        }

        jobDetailViewController.scrollView.contentInset.top = mailViewHeight
        jobDetailViewController.scrollView.scrollIndicatorInsets.top = mailViewHeight
    }

    /**
     ページングがされ、mailViewがまだ表示されているとき、jobDetailのテーブルのスクロールのオフセットを設定
     - parameter index: ページングのindex
     - parameter scroll: どれだけスクロールしているか
     */
    func setupJobDetailScrollContentOffsetY(index: Int, mailViewScrollContentOffsetY: CGFloat) {
        guard let  jobDetailViewController = pageViewControllers[index] as? BAScoutDetailBaseViewControllerProtocol else {
            return
        }

        if mailViewScrollContentOffsetY == 0.0 {
            // 全くスクロールしていないときはmailViewの高さをそのままjobDetailViewのOffsetに設定
            jobDetailViewController.scrollView.contentOffset.y = -mailViewHeight
        } else if (mailViewScrollContentOffsetY < mailViewHeight - scoutDetailMailView.segmentedControlHeight.constant) || (jobDetailViewController.scrollView.contentOffset.y <= -scoutDetailMailView.segmentedControlHeight.constant) {
            // スクロールされているがmailViewが表示されている場合は、スクロール分からmailViewの高さを差し引いた分をoffsetとする
            jobDetailViewController.scrollView.contentOffset.y = mailViewScrollContentOffsetY - mailViewHeight
        }
    }

    /**
     jobDetailのスクロールをmailViewに反映
     - parameter scroll: 移動した分の座標
     */
    func updateMailView(scroll: CGFloat) {
        if shouldScrollMailView {
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
        if let currentIndex = currentIndex, let jobDetailViewController = pageViewControllers[currentIndex] as? BAScoutDetailBaseViewControllerProtocol {
            jobDetailViewController.scrollView.contentOffset.y += scroll
        }
    }

    /**
     メールとJobDetailのスクロールを更新
     */
    func updateContentViewFrame() {
        guard let currentIndex = currentIndex, let jobDetailViewController = pageViewControllers[currentIndex] as? BAScoutDetailBaseViewControllerProtocol else {
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
            let jobDetailViewController = pageViewControllers[updateIndex] as? BAScoutDetailBaseViewControllerProtocol
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

extension BAScoutDetailBaseViewController: UIPageViewControllerDataSource {

    /**
     1つ目のviewControllerに戻った時の処理
     - parameter pageViewController: pageViewController
     - parameter viewController: 現在表示されている2つ目のviewController
     - returns: 1つ目に戻った時に表示されるviewController
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

            guard var index = pageViewControllers.index(of: viewController) else {
                return nil
            }
            
            index = index - 1
            
            if index >= 0 && index < pageViewControllers.count {
                return pageViewControllers[index]
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

        guard var index = pageViewControllers.index(of: viewController) else {
            return nil
        }

        index = index + 1

        if index >= 0 && index < pageViewControllers.count {
            return pageViewControllers[index]
        }
        return nil
    }
}

// MARK: - UIPageViewControllerDelegate

extension BAScoutDetailBaseViewController: UIPageViewControllerDelegate {

    /**
     スワイプでpageViewControllerで別のviewControllerに遷移する時の処理
     - parameter pageViewController: pageViewController
     - parameter pagingViewControllers: これから遷移しようとしているviewController
     */
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let jobDetailViewController = pendingViewControllers.first, let index = pageViewControllers.index(of: jobDetailViewController) {
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
