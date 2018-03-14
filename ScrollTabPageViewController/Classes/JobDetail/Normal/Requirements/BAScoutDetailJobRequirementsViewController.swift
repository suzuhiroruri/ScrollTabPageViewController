//
//  BAScoutDetailJobViewController.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/02/08.
//  Copyright © 2018年 hir-suzuki All rights reserved.
//

import UIKit

extension BAScoutDetailJobRequirementsViewController: BAScoutDetailJobBaseViewControllerProtocol {
    var scrollView: UIScrollView {
        return tableView
    }
}

class BAScoutDetailJobRequirementsViewController: UIViewController, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    var scrollDelegateFunc: ((UIScrollView) -> Void)?
    func scrollViewDidScroll(_ tableView: UIScrollView) {
        if self.scrollDelegateFunc != nil {
            guard let scrollDelegateFunc = self.scrollDelegateFunc else {
                return
            }
            scrollDelegateFunc(tableView)
        }
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
