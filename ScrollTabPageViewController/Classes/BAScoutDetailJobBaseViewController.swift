//
//  BAScoutDetailJobBaseViewController.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/03/06.
//  Copyright © 2018年 hir-suzuki. All rights reserved.
//

import UIKit

protocol BAScoutDetailJobBaseViewControllerProtocol {
    var scrollView: UIScrollView { get }
}

class BAScoutDetailJobBaseViewController: HeaderedCAPSPageMenuViewController, CAPSPageMenuDelegate {

    /// タブにセットするViewController
    private var inTabViewController: [UIViewController] = []

    var lastRequiredHeaderCurrentY: CGFloat = 0.0
    var lastSelectedHeaderCurrentY: CGFloat = 0.0

    /// 募集内容
    private lazy var requirementsViewController: BAScoutDetailJobRequirementsViewController? = {
        let sb = UIStoryboard(name: R.storyboard.bAScoutDetailJobRequirementsViewController.name, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BAScoutDetailJobRequirementsViewController") as? BAScoutDetailJobRequirementsViewController
        return vc
    }()

    /// 選考・会社概要
    private lazy var selectionViewController: BAScoutDetailJobSelectionViewController? = {
        let sb = UIStoryboard(name: R.storyboard.bAScoutDetailJobSelectionViewController.name, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BAScoutDetailJobSelectionViewController") as? BAScoutDetailJobSelectionViewController
        return vc
    }()

    override func viewDidLoad() {
    	let mailView = BAScoutDetailMailView.instantiate()
        headerHeight = mailView.frame.height

        super.viewDidLoad()
        headerView = mailView
        mailView.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }

        self.updateView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		title = "仕事詳細"
    }

    /// 表示更新
    private func updateView() {
        // 初期化済みの場合は実行しない
        guard inTabViewController.isEmpty else {
            return
        }

        // タブ、ViewControllerセット
        self.setInTab()
    }

    /// タブ、ViewControllerをセットする
    private func setInTab() {
        guard let requirementsViewController = requirementsViewController else {
            return
        }
        requirementsViewController.title = "募集内容"

        guard let selectionViewController  = selectionViewController else {
            return
        }
        selectionViewController.title = "選考・会社概要"

        requirementsViewController.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        selectionViewController.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }

        inTabViewController.append(requirementsViewController)
        inTabViewController.append(selectionViewController)

        self.addPageMenu(menu: CAPSPageMenu(viewControllers: inTabViewController, frame: CGRect(x: 0, y: 0, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height+130), pageMenuOptions: nil))
        guard let pageMenuController = pageMenuController else {
            return
        }
        pageMenuController.delegate = self
    }

    // ヘッダーがスクロールされるときに呼ばれる
    override func headerDidScroll(minY: CGFloat, maxY: CGFloat, currentY: CGFloat) {
        updateHeaderPositionAccordingToScrollPosition(minY: minY, maxY: maxY, currentY: currentY)
        guard let currentIndex = self.pageMenuController?.currentPageIndex else {
            return
        }

        if currentIndex == 0 {
            lastRequiredHeaderCurrentY = currentY
        } else {
            lastSelectedHeaderCurrentY = currentY
        }
    }

    // ページングする直前
    func willMoveToPage(_ controller: UIViewController, index: Int) {

        guard let jobDetailViewController = inTabViewController[index] as? BAScoutDetailJobBaseViewControllerProtocol else {
            return
        }

        if jobDetailViewController.scrollView.frame.height != 0 {
           jobDetailViewController.scrollView.showsVerticalScrollIndicator = false
            // 左右でヘッダーのOffsetが変更されていた場合はスクロールをリセットする
            if lastRequiredHeaderCurrentY != lastSelectedHeaderCurrentY {
                lastTabScrollViewOffset.y = 0
                jobDetailViewController.scrollView.contentOffset.y = 0
            }
        }
    }

    // ページングした直後
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        guard let jobDetailViewController = inTabViewController[index] as? BAScoutDetailJobBaseViewControllerProtocol else {
            return
        }
        jobDetailViewController.scrollView.showsVerticalScrollIndicator = true
    }
}
