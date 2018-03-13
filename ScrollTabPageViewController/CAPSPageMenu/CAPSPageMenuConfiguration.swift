//
//  CAPSPageMenuConfiguration.swift
//  PageMenuConfigurationDemo
//
//  Created by Matthew York on 3/5/17.
//  Copyright © 2017 Aeron. All rights reserved.
//

import UIKit

public class CAPSPageMenuConfiguration {
    open var menuHeight: CGFloat = 34.0
    open var menuMargin: CGFloat = 15.0
    open var menuItemWidth: CGFloat = 111.0
    open var scrollAnimationDurationOnMenuItemTap: Int = 500 // Millisecons
    open var selectedMenuItemLabelColor: UIColor = UIColor.white
    open var unselectedMenuItemLabelColor: UIColor = UIColor.lightGray
    open var selectedMenuItemBackgroundColor: UIColor = UIColor.white
    open var unselectedMenuItemBackgroundColor: UIColor = UIColor.lightGray
    open var scrollMenuBackgroundColor: UIColor = UIColor.black
    open var viewBackgroundColor: UIColor = UIColor.white
    open var menuItemFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    open var useMenuLikeSegmentedControl: Bool = false

    public init() {}
}
