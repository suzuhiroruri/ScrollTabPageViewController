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
    var scoutDetailMailView: ContentsView!

    // スカウトメールのビューの高さ
    let mailViewHeight: CGFloat = 280.0

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
        self.setupOutlets()
    }
}


// MARK: - View

extension BAScoutDetailBaseViewController {

    // 各Viewを設定
    func setupOutlets() {
    
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
        scoutDetailMailView = ContentsView(frame: CGRect(x:0.0, y:64.0, width:view.frame.width, height:mailViewHeight))
        // タップでセグメントが変更された時の挙動を設定
        scoutDetailMailView.tabButtonPressedBlock = { [weak self] (index: Int) in
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
                                            uself.setupJobDetailScrollContentOffsetY(index:index, scroll: -uself.mailViewScrollContentOffsetY)
                                            uself.shouldUpdateJobDetailContentOffset = false
                                        }
            })
        }

        // scoutDetailMailViewのDidScrollの時のブロック
        scoutDetailMailView.scrollDidChangedBlock = { [weak self] (scroll: CGFloat, shouldScrollFrame: Bool) in
            self?.shouldScrollMailView = shouldScrollFrame
            // Y座標を更新する
            self?.updateContentOffsetY(scroll: scroll)
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
                self?.setupCurrentContentInset()
            })
    }
}

// MARK: - updateScroll

extension BAScoutDetailBaseViewController {

    /**
     BAScoutDetailJobViewControllerのscrollView(tableView)の上部のマージンをセット
     */
    func setupCurrentContentInset() {
        guard let currentIndex = currentIndex, let jobDetailViewController = pageViewControllers[currentIndex] as? BAScoutDetailBaseViewControllerProtocol else {
            return
        }

        jobDetailViewController.scrollView.contentInset.top = mailViewHeight
        jobDetailViewController.scrollView.scrollIndicatorInsets.top = mailViewHeight
    }
    
    /**
     次のscrollViewのcontentInsetをセット
     */
    func setupNextContentInset(nextIndex:Int) {
        guard let jobDetailViewController = pageViewControllers[nextIndex] as? BAScoutDetailBaseViewControllerProtocol else {
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
    func setupJobDetailScrollContentOffsetY(index: Int, scroll: CGFloat) {
        guard let  jobDetailViewController = pageViewControllers[index] as? BAScoutDetailBaseViewControllerProtocol else {
            return
        }

        if scroll == 0.0 {
            jobDetailViewController.scrollView.contentOffset.y = -mailViewHeight
        } else if (scroll < mailViewHeight - scoutDetailMailView.segmentedControlHeight.constant) || (jobDetailViewController.scrollView.contentOffset.y <= -scoutDetailMailView.segmentedControlHeight.constant) {
            jobDetailViewController.scrollView.contentOffset.y = scroll - mailViewHeight
        }
    }

    /**
     viewControllerのスクロールでのcontentViewを更新
     - parameter scroll: 移動した分の座標
     */
    func updateContentView(scroll: CGFloat) {
        if shouldScrollMailView {
            scoutDetailMailView.frame.origin.y = scroll
            mailViewScrollContentOffsetY = scroll
        }
        shouldScrollMailView = true
    }

    /**
     Y座標を更新
     - parameter scroll: 移動した分の座標
     */
    func updateContentOffsetY(scroll: CGFloat) {
        if let currentIndex = currentIndex, let vc = pageViewControllers[currentIndex] as? BAScoutDetailBaseViewControllerProtocol {
            vc.scrollView.contentOffset.y += scroll
        }
    }

    func updateContentViewFrame() {
        guard let currentIndex = currentIndex, let vc = pageViewControllers[currentIndex] as? BAScoutDetailBaseViewControllerProtocol else {
            return
        }

        // 予めスクロールのcontentOffsetはcontentsViewの分だけ差し引かれている。
        // スクロールの長さがsegmentedControlの高さより大きいかどうか判定
        if vc.scrollView.contentOffset.y >= -scoutDetailMailView.segmentedControlHeight.constant {
            // tableViewのスクロール更新
            let scroll = mailViewHeight - scoutDetailMailView.segmentedControlHeight.constant
            updateContentView(scroll: -scroll)
            vc.scrollView.scrollIndicatorInsets.top = scoutDetailMailView.segmentedControlHeight.constant
        } else {
            // contentsViewとtableViewのスクロール更新
            let scroll = mailViewHeight + vc.scrollView.contentOffset.y
            updateContentView(scroll: -scroll)
            vc.scrollView.scrollIndicatorInsets.top = -vc.scrollView.contentOffset.y
        }
    }

    func updateLayoutIfNeeded() {
        if shouldUpdateJobDetailContentOffset {
            let vc = pageViewControllers[updateIndex] as? BAScoutDetailBaseViewControllerProtocol
            let shouldSetupContentOffsetY = vc?.scrollView.contentInset.top != mailViewHeight
            
            setupCurrentContentInset()
            setupJobDetailScrollContentOffsetY(index: updateIndex, scroll: -mailViewScrollContentOffsetY)
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
        if let vc = pendingViewControllers.first, let index = pageViewControllers.index(of: vc) {
            shouldUpdateJobDetailContentOffset = true
            updateIndex = index
            setupNextContentInset(nextIndex: updateIndex)
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
            setupCurrentContentInset()
            setupJobDetailScrollContentOffsetY(index: currentIndex, scroll: -mailViewScrollContentOffsetY)
        }

        if currentIndex >= 0 && currentIndex < scoutDetailMailView.segmentedControl.numberOfSegments {
            scoutDetailMailView.updateCurrentIndex(index: currentIndex, animated: false)
        }
    }
}
