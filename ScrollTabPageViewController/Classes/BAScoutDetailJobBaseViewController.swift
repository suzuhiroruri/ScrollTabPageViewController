//
//  BAScoutDetailJobBaseViewController2.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/03/06.
//  Copyright © 2018年 EndouMari. All rights reserved.
//

import UIKit

protocol BAScoutDetailJobBaseViewControllerProtocol {
    var scoutDetailJobBaseViewController: BAScoutDetailJobBaseViewController { get }
    var scrollView: UIScrollView { get }
}

class BAScoutDetailJobBaseViewController: HeaderedCAPSPageMenuViewController, CAPSPageMenuDelegate {

    var inTabViewController: [UIViewController] = []

    var lastRequiredHeaderCurrentY: CGFloat = 0.0
    var lastSelectedHeaderCurrentY: CGFloat = 0.0

    /// 募集内容
    lazy var requirementsViewController: BAScoutDetailJobRequirementsViewController? = {
        let sb1 = UIStoryboard(name: R.storyboard.bAScoutDetailJobRequirementsViewController.name, bundle: nil)
        let vc1 = sb1.instantiateViewController(withIdentifier: "BAScoutDetailJobRequirementsViewController") as? BAScoutDetailJobRequirementsViewController
        return vc1
    }()

    /// 選考・会社概要
    lazy var selectionViewController: BAScoutDetailJobSelectionViewController? = {
        let sb1 = UIStoryboard(name: R.storyboard.bAScoutDetailJobSelectionViewController.name, bundle: nil)
        let vc1 = sb1.instantiateViewController(withIdentifier: "BAScoutDetailJobSelectionViewController") as? BAScoutDetailJobSelectionViewController
        return vc1
    }()

    override func viewDidLoad() {
        let mailView = BAScoutDetailMailView.instantiate()
        self.headerHeight = mailView.frame.height

        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.headerView = mailView
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

        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.lightGray),
            .menuItemSeparatorColor(UIColor.clear),
            .viewBackgroundColor(UIColor.lightGray),
            .bottomMenuHairlineColor(UIColor.clear),
            .selectionIndicatorColor(UIColor.clear),
            .menuHeight(44.0),
            .unselectedMenuItemLabelColor(.white),
            .useMenuLikeSegmentedControl(true),
            .selectedMenuItemLabelColor(UIColor.white),
            .menuItemWidthBasedOnTitleTextWidth(false),
            .selectionIndicatorHeight(0.0)
        ]
        self.addPageMenu(menu: CAPSPageMenu(viewControllers: inTabViewController, frame: CGRect(x: 0, y: 0, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height+200), pageMenuOptions: parameters))
        guard let pageMenuController = pageMenuController else {
            return
        }
        pageMenuController.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "仕事詳細"
        UIApplication.shared.statusBarStyle = .lightContent
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

    // ページングする直前
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        guard let jobDetailViewController = inTabViewController[index] as? BAScoutDetailJobBaseViewControllerProtocol else {
            return
        }
        jobDetailViewController.scrollView.showsVerticalScrollIndicator = true
    }
}
