//
//  BAScoutMailHeaderCell.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/03/08.
//  Copyright © 2018年 EndouMari. All rights reserved.
//

import UIKit

class BAScoutMailHeaderCell: UITableViewCell {

    // スカウトメール受信日のラベル
    @IBOutlet weak var mailHeaderLabel: UILabel!
    var scoutDetailMailViewModel: BAScoutDetailMailViewModel? {
        didSet {
            // スカウトメールヘッダーラベル
            mailHeaderLabel.text = scoutDetailMailViewModel?.mailHeader
            mailHeaderLabel.sizeToFit()
        }
    }
}
