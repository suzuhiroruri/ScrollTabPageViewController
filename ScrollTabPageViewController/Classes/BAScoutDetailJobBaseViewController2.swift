//
//  BAScoutDetailJobBaseViewController2.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/03/06.
//  Copyright © 2018年 EndouMari. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class BAScoutDetailJobBaseViewController2: SJSegmentedViewController {

    var selectedSegment: SJSegmentTab?
    //var mailViewController: BAScoutMailViewController?
    var viewController: UIViewController?
    //var mailController: BAScoutMailController?
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
        guard let vc = viewController else {
            return
        }
        headerViewController = vc
        headerViewHeight = vc.view.frame.height

        guard let selectionViewController  = selectionViewController else {
            return
        }
        selectionViewController.title = "選考・会社概要"

        guard let requirementsViewController = requirementsViewController else {
            return
        }
        requirementsViewController.title = "募集内容"

        segmentControllers = [requirementsViewController,
                              selectionViewController]
        selectedSegmentViewHeight = 0
        segmentViewHeight = 44
        segmentBackgroundColor = UIColor.lightGray
        headerViewOffsetHeight = 0.0
        segmentTitleColor = .darkGray
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = true
        segmentBounces = false
        delegate = self
        super.viewDidLoad()
    }
}

extension BAScoutDetailJobBaseViewController2: SJSegmentedViewControllerDelegate {
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {

        if selectedSegment != nil {
            selectedSegment?.titleColor(.darkGray)
            selectedSegment?.backgroundColor = UIColor.lightGray
        }

        if !segments.isEmpty {
            selectedSegment = segments[index]
            selectedSegment?.titleColor(.white)
            selectedSegment?.backgroundColor = UIColor.red
        }
    }
}

extension BAScoutDetailJobBaseViewController2: SJSegmentedViewControllerViewSource {
}
