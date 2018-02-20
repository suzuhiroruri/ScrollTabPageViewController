//
//  BAScoutDetailJobBaseViewController.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/02/20.
//  Copyright © 2018年 hir-suzuki All rights reserved.
//

import UIKit

class BAScoutDetailBaseViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    /// タブにセットするViewController
    private var inTabViewController: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is BAScoutDetailJobViewController {
            return viewController
            //return inTabViewController[0]
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is BAScoutDetailJobViewController {
            return viewController
            //return inTabViewController[1]
        }
        return nil
    }

}
