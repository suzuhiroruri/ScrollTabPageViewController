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
        scoutDetailMailView.bAScoutDetailMailViewProtocol = self
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let currentIndex = self.currentIndex, let jobDetailViewController = self.pageViewControllers[currentIndex] as? BAScoutDetailBaseViewControllerProtocol else {
            return
        }
        // 初期表示の時にスクロールの位置がずれてしまう場合、修正する
        if -jobDetailViewController.scrollView.contentOffset.y < scoutDetailMailView.frame.height {
            jobDetailViewController.scrollView.contentOffset.y = -scoutDetailMailView.frame.height
        }
    }
}

// MARK: - View

extension BAScoutDetailBaseViewController: BAScoutDetailMailViewProtocol {

    // スカウト特典についてのWebView表示
    func showAboutBenefitView() {
        // TODO:バイトルに入れる時はtoFreeWebにする
        let modal = BAScoutDetailAboutBenefitViewController()
        self.present(modal, animated: true, completion: nil)
    }

    // 各Viewを設定
    func setupViews() {
        // スカウトメールのビューをセットアップ
        self.setupScoutDetailMailView()
        // 仕事詳細のcontrollerをセットアップ
        self.setupJobDetailViewControllers()
        // pageViewControllerに仕事詳細のcontrollerを格納
        self.setupPageViewController()
    }

    // BAScoutDetailJobViewControllerをセットアップ
    // 別々のviewControllerを設定する場合はvc1&2の読み込み内容を変更する
    func setupJobDetailViewControllers() {
        // viewContrroller
        let sb1 = UIStoryboard(name: R.storyboard.bAScoutDetailJobViewController.name, bundle: nil)
        let vc1 = sb1.instantiateViewController(withIdentifier: "BAScoutDetailJobViewController")

        // viewContrroller
        let sb2 = UIStoryboard(name: R.storyboard.bAScoutDetailJobViewController.name, bundle: nil)
        let vc2 = sb2.instantiateViewController(withIdentifier: "BAScoutDetailJobViewController")

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
            self?.shouldUpdateJobDetailContentOffset = true

            self?.updateIndex = index
            guard let currentIndex = self?.currentIndex else {
                return
            }
            let direction: UIPageViewControllerNavigationDirection = (currentIndex < index) ? .forward : .reverse
            guard let pageViewControllers = self?.pageViewControllers else {
                return
            }
            self?.setViewControllers([pageViewControllers[index]],
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

        // scoutDetailMailViewのDidScrollの時のブロック
        scoutDetailMailView.mailScrollDidChangedBlock = { [weak self] (scroll: CGFloat, shouldScrollMailView: Bool) in
            guard let currentIndex = self?.currentIndex, let jobDetailViewController = self?.pageViewControllers[currentIndex] as? BAScoutDetailBaseViewControllerProtocol else {
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
        } else if mailViewScrollContentOffsetY <= (mailViewHeight - scoutDetailMailView.segmentedControlHeight.constant) ||
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
        if let currentIndex = currentIndex, let jobDetailViewController = pageViewControllers[currentIndex] as? BAScoutDetailBaseViewControllerProtocol {
            // jobDetailのテーブルのスクロールのY座標を更新を反映させている間、userInteractionを許可しないことにより、意図しないスクロールのずれを防ぐ
            jobDetailViewController.scrollView.isUserInteractionEnabled = false
            jobDetailViewController.scrollView.contentOffset.y += scroll
            jobDetailViewController.scrollView.isUserInteractionEnabled = true
        }
    }

    // jobDetailTableのスクロールがずれたときの補正を行う
    func updateJobDetailViewFrame() {
        guard let currentIndex = currentIndex, let jobDetailViewController = pageViewControllers[currentIndex] as? BAScoutDetailBaseViewControllerProtocol else {
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

            index -= 1

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

        index += 1

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
