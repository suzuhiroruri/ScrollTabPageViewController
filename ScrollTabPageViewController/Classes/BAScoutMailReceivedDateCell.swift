//
//  BAScoutMailReceivedDateCell.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/03/08.
//  Copyright © 2018年 EndouMari. All rights reserved.
//

import UIKit

class BAScoutMailReceivedDateCell: UITableViewCell {
    // スカウトメール受信日のラベル
    @IBOutlet weak var receivedDateLabel: UILabel!
    var scoutDetailMailViewModel: BAScoutDetailMailViewModel? {
        didSet {
            guard let isFromSubscribeList = scoutDetailMailViewModel?.isFromSubscribeList else {
                return
            }
            // スカウトメール受信日ラベル
            receivedDateLabel.textColor = isFromSubscribeList ? UIColor.red : UIColor.black
            receivedDateLabel.text = scoutDetailMailViewModel?.receivedDate
        }
    }
}
