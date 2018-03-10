//
//  BAScoutDetailJobBaseViewController2.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/03/06.
//  Copyright © 2018年 EndouMari. All rights reserved.
//

import UIKit
//import HeaderedTabScrollView
import PageMenu

class BAScoutDetailJobBaseViewController: HeaderedCAPSPageMenuViewController, CAPSPageMenuDelegate {
    let tabsTexts = ["Submissions", "Comments"]
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
    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false
        let mailView = BAScoutDetailMailView.instantiate()
        self.headerHeight = mailView.frame.height
        print(self.headerHeight)
        super.viewDidLoad()
        self.headerView = mailView
        guard let requirementsViewController = requirementsViewController else {
            return
        }
        requirementsViewController.title = "1"

        guard let selectionViewController  = selectionViewController else {
            return
        }
        selectionViewController.title = "2"
        requirementsViewController.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        selectionViewController.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        var controllers: [UIViewController] = []
        controllers.append(requirementsViewController)
        controllers.append(selectionViewController)
        let parameters: [CAPSPageMenuOption] = [
            .menuItemWidth(50),
            .scrollMenuBackgroundColor(#colorLiteral(red: 0.07058823529, green: 0.09411764706, blue: 0.1019607843, alpha: 0.5)),
            .viewBackgroundColor(#colorLiteral(red: 0.07058823529, green: 0.09411764706, blue: 0.1019607843, alpha: 0.5)),
            .bottomMenuHairlineColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.1)),
            .selectionIndicatorColor(#colorLiteral(red: 0.8404174447, green: 0.396413058, blue: 0, alpha: 1)),
            .menuMargin(0.0),
            .menuHeight(40.0),
            .selectedMenuItemLabelColor(.white),
            .unselectedMenuItemLabelColor(.white),
            .useMenuLikeSegmentedControl(true),
            .selectionIndicatorHeight(2.0),
            .menuItemWidthBasedOnTitleTextWidth(false)
        ]
        self.addPageMenu(menu: CAPSPageMenu(viewControllers: controllers, frame: CGRect(x: 0, y: 0, width: pageMenuContainer.frame.width, height: pageMenuContainer.frame.height+200), pageMenuOptions: parameters))
        self.pageMenuController!.delegate = self
        self.navBarTransparancy = 1
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavBarTitle(title: "Curtis' profile")
        self.navBarColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
        self.navBarTransparancy = 1
    }
    override func headerDidScroll(minY: CGFloat, maxY: CGFloat, currentY: CGFloat) {
        updateHeaderPositionAccordingToScrollPosition(minY: minY, maxY: maxY, currentY: currentY)
    }
}
