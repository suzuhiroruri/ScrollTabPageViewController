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
        if let bAScoutDetailJobBaseViewController = segue.destination as? BAScoutDetailJobBaseViewController {
        }
    }
}
