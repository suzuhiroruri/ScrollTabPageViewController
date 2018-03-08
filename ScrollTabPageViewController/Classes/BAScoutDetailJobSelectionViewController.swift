//
//  BAScoutDetailJobViewController.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/02/08.
//  Copyright © 2018年 hir-suzuki All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class BAScoutDetailJobSelectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = edgeInsets
        tableView.scrollIndicatorInsets = edgeInsets
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //scoutDetailJobBaseViewController.updateJobDetailLayoutIfNeeded()
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
extension BAScoutDetailJobSelectionViewController: SJSegmentedViewControllerViewSource {
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        return tableView
    }
}

// MARK: - UIScrollViewDelegate

extension BAScoutDetailJobSelectionViewController: UITableViewDelegate {
    /*
    /**
     スクロールのドラッグ開始を検知
     - parameter scrollView: scrollView
     */
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // スカウトメールのセグメントのインタラクションを利用不可にする(mailとjobのスクロールのずれ防止のため)
        scoutDetailJobBaseViewController.scoutDetailMailView.segmentedControl.isUserInteractionEnabled = false
        scoutDetailJobBaseViewController.scoutDetailMailView.scrollView.bounces = false
    }

    /**
     スクロールを検知
     - parameter scrollView: scrollView
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scoutDetailMailViewのスクロールを同期
        scoutDetailJobBaseViewController.updateContentViewFrame()
    }

    /**
     スクロールのドラッグ終了を検知
     - parameter scrollView: scrollView
     */
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !scrollView.isDecelerating && !scrollView.isDragging {
            // ドラッグや慣性が検出されない場合
            // 利用不可にしていたスカウトメールのセグメントのインタラクションを利用可能にする
            scoutDetailJobBaseViewController.scoutDetailMailView.segmentedControl.isUserInteractionEnabled = true
            scoutDetailJobBaseViewController.scoutDetailMailView.scrollView.bounces = true
        }
    }

    /**
     スクロールの慣性終了を検知
     - parameter scrollView: scrollView
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 利用不可にしていたスカウトメールのセグメントのインタラクションを利用可能にする
        scoutDetailJobBaseViewController.scoutDetailMailView.segmentedControl.isUserInteractionEnabled = true
        scoutDetailJobBaseViewController.scoutDetailMailView.scrollView.bounces = true
    }
    */

}

// MARK: - ScrollTabPageViewControllerProtocol
/*
extension BAScoutDetailJobSelectionViewController: BAScoutDetailJobBaseViewControllerProtocol {

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
*/
