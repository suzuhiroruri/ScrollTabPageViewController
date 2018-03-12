//
//  BAScoutDetailJobViewController.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/02/08.
//  Copyright © 2018年 hir-suzuki All rights reserved.
//

import UIKit

class BAScoutDetailJobSelectionViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = edgeInsets
        tableView.scrollIndicatorInsets = edgeInsets
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - UITableVIewDataSource

extension BAScoutDetailJobSelectionViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
}

extension BAScoutDetailJobSelectionViewController: BAScoutDetailJobBaseViewControllerProtocol {

    var scoutDetailJobBaseViewController: BAScoutDetailJobBaseViewController {
        guard let baseController = parent?.parent as? BAScoutDetailJobBaseViewController else {
            return BAScoutDetailJobBaseViewController()
        }
        return baseController
    }

    var scrollView: UIScrollView {
        guard let tableView = tableView else {
            return UITableView()
        }
        return tableView
    }
}
