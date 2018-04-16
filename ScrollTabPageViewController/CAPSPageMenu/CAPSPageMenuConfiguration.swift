//
//  CAPSPageMenuConfiguration.swift
//  PageMenuConfigurationDemo
//
//  Created by Matthew York on 3/5/17.
//  Copyright © 2017 Aeron. All rights reserved.
//

import UIKit

public class CAPSPageMenuConfiguration {
    /// ページビューの背景色
    open var viewBackgroundColor: UIColor = UIColor(red: 224 / 255.0, green: 224 / 255.0, blue: 224 / 255.0, alpha: 1)
    /// セグメントの高さ
    open var menuHeight: CGFloat = 44.0
    /// セグメントの選択ラベルの文字色
    open var selectedMenuItemLabelColor: UIColor = UIColor.white
    /// セグメントの非選択ラベルの文字色
    open var unselectedMenuItemLabelColor: UIColor = UIColor.gray
    /// セグメントの選択ラベルの背景色
    open var selectedMenuItemBackgroundColor: UIColor = UIColor.red
    /// セグメントの非選択ラベルの背景色
    open var unselectedMenuItemBackgroundColor: UIColor = UIColor(red: 224 / 255.0, green: 224 / 255.0, blue: 224 / 255.0, alpha: 1)
    /// セグメントのフォント
    open var menuItemFont: UIFont = UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)

    public init() {}
}
