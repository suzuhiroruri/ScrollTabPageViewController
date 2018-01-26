//
//  BAScoutDetailJobViewController.swift
//  ScrollTabPageViewController
//
//  Created by EndouMari on 2015/12/06.
//  Copyright © 2015年 EndouMari. All rights reserved.
//

import UIKit

class BAScoutDetailJobViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scoutDetailBaseViewController.updateJobDetailLayoutIfNeeded()
    }
}

// MARK: - UITableVIewDataSource

extension BAScoutDetailJobViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
}

// MARK: - UIScrollViewDelegate

extension BAScoutDetailJobViewController: UITableViewDelegate {

    /**
     viewControllerへのスクロールを検知
     - parameter scrollView: scrollView
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // scoutDetailMailViewのスクロールを同期
        scoutDetailBaseViewController.updateContentViewFrame()
    }
}

// MARK: - ScrollTabPageViewControllerProtocol

extension BAScoutDetailJobViewController: BAScoutDetailBaseViewControllerProtocol {

    var scoutDetailBaseViewController: BAScoutDetailBaseViewController {
        guard let baseController = parent as? BAScoutDetailBaseViewController else {
            return BAScoutDetailBaseViewController()
        }
        return baseController
    }

    var scrollView: UIScrollView {
        return tableView
    }
}
