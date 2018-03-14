//
//  CAPSPageMenuConfiguration.swift
//  PageMenuConfigurationDemo
//
//  Created by Matthew York on 3/5/17.
//  Copyright © 2017 Aeron. All rights reserved.
//

import UIKit

public class CAPSPageMenuConfiguration {
    open var menuHeight: CGFloat = 44.0
    open var menuMargin: CGFloat = 15.0
    open var scrollAnimationDurationOnMenuItemTap: Int = 500 // Millisecons
    open var selectedMenuItemLabelColor: UIColor = UIColor.white
    open var unselectedMenuItemLabelColor: UIColor = UIColor.gray
    open var selectedMenuItemBackgroundColor: UIColor = UIColor.red
    open var unselectedMenuItemBackgroundColor: UIColor = UIColor(red: 224 / 255.0, green: 224 / 255.0, blue: 224 / 255.0, alpha: 1)
    open var scrollMenuBackgroundColor: UIColor = UIColor.lightGray
    open var viewBackgroundColor: UIColor = UIColor.lightGray
    open var menuItemFont: UIFont = UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)

    public init() {}
}
