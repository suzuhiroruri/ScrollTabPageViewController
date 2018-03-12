//
//  BAScoutDetailJobViewController.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/02/08.
//  Copyright © 2018年 hir-suzuki All rights reserved.
//

import UIKit
//import PageMenu

extension BAScoutDetailJobRequirementsViewController: BAScoutDetailJobBaseViewControllerProtocol {

    var scoutDetailJobBaseViewController: BAScoutDetailJobBaseViewController {
        guard let baseController = parent?.parent as? BAScoutDetailJobBaseViewController else {
            return BAScoutDetailJobBaseViewController()
        }
        return baseController
    }

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
        /*
        automaticallyAdjustsScrollViewInsets = false
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        tableView.contentInset = edgeInsets
        tableView.scrollIndicatorInsets = edgeInsets
        */
        /*
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
 
        tableView.isScrollEnabled = true
        tableView.alwaysBounceVertical = true
        */
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
