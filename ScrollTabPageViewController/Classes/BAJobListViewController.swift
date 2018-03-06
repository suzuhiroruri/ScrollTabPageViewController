//
//  BAJobListViewController.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/02/20.
//  Copyright © 2018年 hir-suzuki All rights reserved.
//

import UIKit

class BAJobListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func buttonTap(_ sender: UIButton) {
        performSegue(withIdentifier: "BAScoutDetailJobBase", sender: nil)
    }

}
