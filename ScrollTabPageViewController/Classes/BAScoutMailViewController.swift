//
//  BAScoutMailViewController.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/03/07.
//  Copyright © 2018年 EndouMari. All rights reserved.
//

import UIKit

protocol BAScoutMailViewControllerProtocol: class {
    func updateHeight(height: CGFloat)
}
class BAScoutMailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: BAScoutMailViewControllerProtocol?
    var scoutDetailMailViewModel: BAScoutDetailMailViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        scoutDetailMailViewModel = BAScoutDetailMailViewModel.init()
        tableView.register(UINib(nibName: "BAScoutMailReceivedDateCell", bundle: nil), forCellReuseIdentifier: "scoutMailReceivedDateCell")
        tableView.register(UINib(nibName: "BAScoutMailHeaderCell", bundle: nil), forCellReuseIdentifier: "mailHeader")

        tableView.dataSource = self
        tableView.delegate = self

        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.reloadData()
        let height = tableView.contentSize.height
        delegate?.updateHeight(height: height)
        print("\n",
              "height",
              "\n",
              height
        )
    }
    func prepare() {
        print("\n",
              "print",
              "\n",
              "print"
        )
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "scoutMailReceivedDateCell", for: indexPath) as? BAScoutMailReceivedDateCell else {
                return UITableViewCell()
            }
            cell.scoutDetailMailViewModel = scoutDetailMailViewModel
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "mailHeader", for: indexPath) as? BAScoutMailHeaderCell else {
                return UITableViewCell()
            }
            cell.scoutDetailMailViewModel = scoutDetailMailViewModel
            return cell
        } else {
            let cell = BAScoutMailTableViewCell()
            cell.textLabel?.text = "あ"
            let height = tableView.contentSize.height
            delegate?.updateHeight(height: height)
            print("\n",
                  "height",
                  "\n",
                  height
            )
            return cell
        }
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        //Get the height required for the TableView to show all cells
        if indexPath.row == (tableView.indexPathsForVisibleRows?.last! as! NSIndexPath).row {
            //End of loading all Visible cells
            let height = tableView.contentSize.height
            print("\n",
                  "height",
                  "\n",
                  height
            )
            delegate?.updateHeight(height: height)
            //If cell's are more than 10 or so that it could not fit on the tableView's visible area then you have to go for other way to check for last cell loaded
        }
    }
}
