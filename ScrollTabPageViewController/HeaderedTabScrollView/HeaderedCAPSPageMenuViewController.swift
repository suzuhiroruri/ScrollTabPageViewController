//
//  HeaderedCAPSPageMenuViewController.swift
//  HeaderedTabScrollView
//
//  Created by Stéphane Sercu on 2/10/17.
//

import UIKit

/**
 Basically an PagingMenu with an header on top of it with some cool scrolling effects.
 */
open class HeaderedCAPSPageMenuViewController: AbstractHeaderedTabScrollViewController {
    public var pageMenuController: CAPSPageMenu?
    public let pageMenuContainer = UIView()

    override open func viewDidLoad() {
        super.viewDidLoad()
        // PageMenu
        self.view.addSubview(pageMenuContainer)
        pageMenuContainer.frame = CGRect(x: 0, y: headerHeight, width: UIScreen.main.bounds.size.width, height: self.view.frame.height - navBarOffset())
        pageMenuContainer.translatesAutoresizingMaskIntoConstraints = false
        // 左
        pageMenuContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        // 右
        pageMenuContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        // 上
        tabTopConstraint = pageMenuContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: headerHeight)
        guard let tabTopConstraint = tabTopConstraint else {
            return
        }
        tabTopConstraint.isActive = true
        pageMenuContainer.heightAnchor.constraint(equalToConstant: self.view.frame.height - navBarOffset()).isActive = true
    }

    public func addPageMenu(menu: CAPSPageMenu) {
        pageMenuController = menu
        guard let pageMenuController = pageMenuController else {
            return
        }
        pageMenuContainer.addSubview(pageMenuController.view)
    }
}
