//
//  BAScoutMailController.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/03/07.
//  Copyright © 2018年 EndouMari. All rights reserved.
//

import UIKit

class BAScoutMailController: UIViewController {
    // スカウトメールのビュー
    var scoutDetailMailView: BAScoutDetailMailView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        /*
        // scoutMailViewを生成
        let scoutDetailMailView = BAScoutDetailMailView.instantiate()
        view.addSubview(scoutDetailMailView)
        let height = self.view.frame.height
        print("\n",
              "height!!",
              "\n",
              height
        )
        */
        // Do any additional setup after loading the view.

    }
}
