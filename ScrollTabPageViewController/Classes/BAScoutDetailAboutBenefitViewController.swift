//
//  BAScoutDetailAboutBenefitViewController.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/02/08.
//  Copyright © 2018年 EndouMari. All rights reserved.
//

import UIKit

class BAScoutDetailAboutBenefitViewController: UIViewController {
    @IBOutlet var aboutScoutBenefit: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        aboutScoutBenefit.title = "スカウト特典について"
        // Do any additional setup after loading the view.
    }

    @IBAction func tapDismissButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}
