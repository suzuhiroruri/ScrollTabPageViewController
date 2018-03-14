//
//  CAPSPageMenu+Configuration.swift
//  PageMenuNoStoryboardConfigurationDemo
//
//  Created by Matthew York on 3/6/17.
//  Copyright © 2017 UACAPS. All rights reserved.
//

import UIKit

extension CAPSPageMenu {
    func configurePageMenu(options: [CAPSPageMenuOption]) {
        for option in options {
            switch (option) {
            case let .viewBackgroundColor(value):
                configuration.viewBackgroundColor = value
            case let .menuHeight(value):
                configuration.menuHeight = value
            case let .selectedMenuItemLabelColor(value):
                configuration.selectedMenuItemLabelColor = value
            case let .unselectedMenuItemLabelColor(value):
                configuration.unselectedMenuItemLabelColor = value
            case let .selectedMenuItemBackgroundColor(value):
                configuration.selectedMenuItemBackgroundColor = value
            case let .unselectedMenuItemBackgroundColor(value):
                configuration.unselectedMenuItemBackgroundColor = value
            case let .menuItemFont(value):
                configuration.menuItemFont = value
            }
        }
    }

    func setUpUserInterface() {
        let viewsDictionary = ["menuScrollView": menuScrollView, "controllerScrollView": controllerScrollView]

        // Set up controller scroll view
        controllerScrollView.isPagingEnabled = true
        controllerScrollView.translatesAutoresizingMaskIntoConstraints = false

        controllerScrollView.frame = CGRect(x: 0.0, y: configuration.menuHeight, width: self.view.frame.width, height: self.view.frame.height)

        self.view.addSubview(controllerScrollView)

        let controllerScrollView_constraint_H: Array = NSLayoutConstraint.constraints(withVisualFormat: "H:|[controllerScrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let controllerScrollView_constraint_V: Array = NSLayoutConstraint.constraints(withVisualFormat: "V:|[controllerScrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)

        self.view.addConstraints(controllerScrollView_constraint_H)
        self.view.addConstraints(controllerScrollView_constraint_V)

        // Set up menu scroll view
        menuScrollView.translatesAutoresizingMaskIntoConstraints = false

        menuScrollView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: configuration.menuHeight)

        self.view.addSubview(menuScrollView)

        let menuScrollView_constraint_H: Array = NSLayoutConstraint.constraints(withVisualFormat: "H:|[menuScrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let menuScrollView_constraint_V: Array = NSLayoutConstraint.constraints(withVisualFormat: "V:[menuScrollView(\(configuration.menuHeight))]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)

        self.view.addConstraints(menuScrollView_constraint_H)
        self.view.addConstraints(menuScrollView_constraint_V)

        // Disable scroll bars
        menuScrollView.showsHorizontalScrollIndicator = false
        menuScrollView.showsVerticalScrollIndicator = false
        controllerScrollView.showsHorizontalScrollIndicator = false
        controllerScrollView.showsVerticalScrollIndicator = false

        // Set background color behind scroll views and for menu scroll view
        self.view.backgroundColor = configuration.viewBackgroundColor
    }

    func configureUserInterface() {
        // Add tap gesture recognizer to controller scroll view to recognize menu item selection
        let menuItemTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CAPSPageMenu.handleMenuItemTap(_:)))
        menuItemTapGestureRecognizer.numberOfTapsRequired = 1
        menuItemTapGestureRecognizer.numberOfTouchesRequired = 1
        menuItemTapGestureRecognizer.delegate = self
        menuScrollView.addGestureRecognizer(menuItemTapGestureRecognizer)

        // Set delegate for controller scroll view
        controllerScrollView.delegate = self

        // When the user taps the status bar, the scroll view beneath the touch which is closest to the status bar will be scrolled to top,
        // but only if its `scrollsToTop` property is YES, its delegate does not return NO from `shouldScrollViewScrollToTop`, and it is not already at the top.
        // If more than one scroll view is found, none will be scrolled.
        // Disable scrollsToTop for menu and controller scroll views so that iOS finds scroll views within our pages on status bar tap gesture.
        menuScrollView.scrollsToTop = false
        controllerScrollView.scrollsToTop = false

        menuScrollView.isScrollEnabled = false
        menuScrollView.contentSize = CGSize(width: self.view.frame.width, height: configuration.menuHeight)

        // Configure controller scroll view content size
        controllerScrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(controllerArray.count), height: 0.0)

        var index: CGFloat = 0.0

        for controller in controllerArray {
            if index == 0.0 {
                // Add first two controllers to scrollview and as child view controller
                controller.viewWillAppear(true)
                addPageAtIndex(0)
                controller.viewDidAppear(true)
            }

            // Set up menu item for menu scroll view
            var menuItemFrame: CGRect = CGRect()

            menuItemFrame = CGRect(x: self.view.frame.width / CGFloat(controllerArray.count) * CGFloat(index), y: 0.0, width: CGFloat(self.view.frame.width) / CGFloat(controllerArray.count), height: configuration.menuHeight)

            let menuItemView: MenuItemView = MenuItemView(frame: menuItemFrame)
            menuItemView.configure(for: self, controller: controller, index: index)

            // Add menu item view to menu scroll view
            menuScrollView.addSubview(menuItemView)
            menuItems.append(menuItemView)

            index += 1
        }

        // Set selected color for title label of selected menu item
        if !menuItems.isEmpty {
            if menuItems[currentPageIndex].titleLabel != nil {
                guard let titleLabel = menuItems[currentPageIndex].titleLabel else {
                    return
                }
                titleLabel.backgroundColor = configuration.selectedMenuItemBackgroundColor
                titleLabel.textColor = configuration.selectedMenuItemLabelColor
            }
        }
    }
}
