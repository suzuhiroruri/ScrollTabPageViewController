//
//  BAJobListViewController.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/02/20.
//  Copyright © 2018年 hir-suzuki All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class BAJobListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonTap(_ sender: UIButton) {

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bAScoutDetailJobBaseViewController2 = segue.destination as? BAScoutDetailJobBaseViewController2 {
            let mailView = BAScoutDetailMailView.instantiate()

            let viewController = UIViewController()
            viewController.view.frame = mailView.frame

            viewController.view.addSubview(mailView)

            bAScoutDetailJobBaseViewController2.viewController = viewController
        }
    }
}
