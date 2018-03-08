//
//  BAScoutDetailJobViewController.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/02/08.
//  Copyright © 2018年 hir-suzuki All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class BAScoutDetailJobRequirementsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        automaticallyAdjustsScrollViewInsets = false
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = edgeInsets
        tableView.scrollIndicatorInsets = edgeInsets
    }
}

// MARK: - UITableVIewDataSource

extension BAScoutDetailJobRequirementsViewController: UITableViewDataSource {

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

extension BAScoutDetailJobRequirementsViewController: SJSegmentedViewControllerViewSource {
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        return tableView
    }
}
