//
//  MenuItemView.swift
//  PageMenuConfigurationDemo
//
//  Created by Matthew York on 3/5/17.
//  Copyright © 2017 Aeron. All rights reserved.
//

import UIKit

class MenuItemView: UIView {
    // MARK: - Menu item view

    var titleLabel: UILabel?

    func setUpMenuItemView(_ menuItemWidth: CGFloat, menuScrollViewHeight: CGFloat) {
        titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: menuItemWidth, height: menuScrollViewHeight - 0))
        guard let titleLabel = titleLabel else {
            return
        }
        self.addSubview(titleLabel)
    }

    func setTitleText(_ text: NSString) {
        if titleLabel != nil {
            guard let titleLabel = titleLabel else {
                return
            }
            titleLabel.text = text as String
            titleLabel.numberOfLines = 0
            titleLabel.sizeToFit()
        }
    }

    func configure(for pageMenu: CAPSPageMenu, controller: UIViewController, index: CGFloat) {
        if pageMenu.menuItemMargin > 0 {
            let marginSum = pageMenu.menuItemMargin * CGFloat(pageMenu.controllerArray.count + 1)
            let menuItemWidth = (pageMenu.view.frame.width - marginSum) / CGFloat(pageMenu.controllerArray.count)
            self.setUpMenuItemView(menuItemWidth,
                                   menuScrollViewHeight: pageMenu.configuration.menuHeight)
        } else {
            self.setUpMenuItemView(CGFloat(pageMenu.view.frame.width) / CGFloat(pageMenu.controllerArray.count),
                                   menuScrollViewHeight: pageMenu.configuration.menuHeight)
        }

        guard let titleLabel = titleLabel else {
            return
        }
        // Configure menu item label font if font is set by user
        titleLabel.font = pageMenu.configuration.menuItemFont

        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = pageMenu.configuration.unselectedMenuItemLabelColor
        titleLabel.backgroundColor = pageMenu.configuration.unselectedMenuItemBackgroundColor

        // Set title depending on if controller has a title set
        if controller.title != nil {
            guard let controllerTitle = controller.title else {
                return
            }
            self.titleLabel?.text  = controllerTitle
        } else {
            self.titleLabel?.text = "Menu \(Int(index) + 1)"
        }
    }
}
