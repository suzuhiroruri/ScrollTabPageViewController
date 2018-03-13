//
//  BAScoutDetailBenefitCollectionCell.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/02/07.
//  Copyright © 2018年 hir-suzuki All rights reserved.
//

import UIKit

class BAScoutDetailBenefitCollectionCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // セルの枠線の色
        self.layer.borderColor = UIColor.blue.cgColor
        // セルの枠線の角
        self.layer.cornerRadius = 4
        // セルの枠線太さ
        self.layer.borderWidth = 1.0
    }
}
