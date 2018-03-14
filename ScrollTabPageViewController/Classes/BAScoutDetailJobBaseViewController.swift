//
//  BAScoutDetailJobBaseViewController.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/03/06.
//  Copyright © 2018年 hir-suzuki. All rights reserved.
//

import UIKit

protocol BAScoutDetailJobBaseViewControllerProtocol {
	// ページビューのcontrollerのスクロールビュー
    var scrollView: UIScrollView { get }
}

class BAScoutDetailJobBaseViewController: HeaderedCAPSPageMenuViewController, CAPSPageMenuDelegate {

    /// タブにセットするViewController
    private var inTabViewController: [UIViewController] = []

    /// 募集内容タブのメールヘッダーのスクロールOffset
    var lastRequiredHeaderOffsetY: CGFloat = 0.0
    /// 選考・会社概要タブのメールヘッダーのスクロールOffset
    var lastSelectedHeaderOffsetY: CGFloat = 0.0

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
        // ヘッダーとしてメールのビューを生成
    	let mailView = BAScoutDetailMailView.instantiate()
        // ヘッダーのビューの高さを指定
        headerHeight = mailView.frame.height

        super.viewDidLoad()

        // ヘッダービューに生成したメールビューを格納
        headerView = mailView
        // メールビューのスクロールを検知して画面全体or仕事詳細部分をスクロールさせるようにセット
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

        // ページに関する設定を格納
        self.addPageMenu(menu: CAPSPageMenu(viewControllers: inTabViewController, frame: CGRect(x: 0, y: 0, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height+130), pageMenuOptions: nil))
        guard let pageMenuController = pageMenuController else {
            return
        }
        pageMenuController.delegate = self
    }

    /// タブスクロールビューがスクロールされるときに呼ばれる
    ///
    /// - Parameter minY:最上部スクロール可能Offset
    /// - Parameter maxY:最下部スクロール可能Offset
    /// - Parameter currentY:現在のスクロールOffset
    override func headerDidScroll(minY: CGFloat, maxY: CGFloat, currentY: CGFloat) {
        // 画面Scrollに応じてタブをスクロールさせる
        updateHeaderPositionAccordingToScrollPosition(minY: minY, maxY: maxY, currentY: currentY)

        // 現在表示している画面incex
        guard let currentIndex = self.pageMenuController?.currentPageIndex else {
            return
        }

        if currentIndex == 0 {
            lastRequiredHeaderOffsetY = currentY
        } else {
            lastSelectedHeaderOffsetY = currentY
        }
    }

    /// ページングする直前に呼ばれる処理
    ///
    /// - Parameter controller: ページング先ViewController
    /// - Parameter index: 画面インデックス
    func willMoveToPage(_ controller: UIViewController, index: Int) {

        // ページング予定のviewController
        guard let nextViewController = controller as? BAScoutDetailJobBaseViewControllerProtocol else {
            return
        }

        if nextViewController.scrollView.frame.height != 0 {
            // タブ左右でヘッダーのOffsetが変更されていた場合はスクロールをリセットする
            if lastRequiredHeaderOffsetY != lastSelectedHeaderOffsetY {
                lastTabScrollViewOffset.y = 0
                nextViewController.scrollView.contentOffset.y = 0
            }
        }
    }
}
