//
//  AbstractHeaderedTabScrollViewController.swift
//  HeaderedTabScrollView
//
//  Created by Stéphane Sercu on 7/07/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import UIKit

/**
 Base view controller
 */
open class AbstractHeaderedTabScrollViewController: UIViewController {

    // MARK: - Private members
    // ====================================

    /// Parent view of the header
    private let headerContainer = UIView()
    /// Constraint on the height of the header
    private var headerHeightConstraint: NSLayoutConstraint?
    ///constraint on the top of the header
    var headerTopConstraint: NSLayoutConstraint?

    /// Constraint on the top of the tabScrollView
    var tabTopConstraint: NSLayoutConstraint?
    /// Remembers the last position (since last viewDidScroll event) of the tabScrollView (relatively to the top of the view)
    //private var lastTabScrollViewOffset: CGPoint = .zero
    public var lastTabScrollViewOffset: CGPoint = .zero

    /// Handle the tranparency of the navBar
    private var navBarOverlay: UIView?

    // MARK: - Public attributes
    // ====================================

    /// The view pinned on top of the tabScrollview
    public var headerView: UIView? {
        didSet {
            if let headerView = headerView {
                headerContainer.subviews.forEach({ $0.removeFromSuperview() })
                headerContainer.addSubview(headerView)
                headerView.translatesAutoresizingMaskIntoConstraints = false
                headerView.topAnchor.constraint(equalTo: headerContainer.topAnchor).isActive = true
                headerView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor).isActive = true
                headerView.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor).isActive = true
                headerView.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor).isActive = true
            }
        }
    }

    /// Height of the header
    public var headerHeight: CGFloat = 210 {
        didSet {
            if let constraint = headerHeightConstraint {
                constraint.constant = headerHeight
            }
        }
    }

    // MARK: - Initialisation
    // ===================================

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Header
        self.view.addSubview(headerContainer)
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerTopConstraint = headerContainer.topAnchor.constraint(equalTo: self.view.topAnchor)
        guard let headerTopConstraint = headerTopConstraint else {
            return
        }
        headerTopConstraint.isActive = true
        headerContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerHeightConstraint = headerContainer.heightAnchor.constraint(equalToConstant: self.headerHeight)
        guard let headerHeightConstraint = headerHeightConstraint else {
            return
        }
        headerHeightConstraint.isActive = true
        lastTabScrollViewOffset = CGPoint(x: CGFloat(0), y: navBarOffset())

    }

    // MARK: - Scroll management
    // ====================================

    /**
     Handles all the effects hapening on a scroll event. You have
     to bind this method to the viewDidScroll action of the subpages' scrollView.
     */
    // 上が動くとき:tabTopConstraint!.constantが動く
    // 下が動くとき:lastTabScrollViewOffset.yが動く
    public func pleaseScroll(_ scrollView: UIScrollView) {
        var delta =  scrollView.contentOffset.y - lastTabScrollViewOffset.y

        // Vertical bounds
        let maxY: CGFloat = navBarOffset()
        let minY: CGFloat = self.headerHeight

        if tabTopConstraint == nil { return }
        // ヘッダービューを縮める(上スクロール)
        guard let tabTopConstraint = tabTopConstraint else {
            return
        }
        if delta > 0 && tabTopConstraint.constant > maxY && scrollView.contentOffset.y > 0 {
            if tabTopConstraint.constant - delta < maxY {
                delta = tabTopConstraint.constant - maxY
            }
            tabTopConstraint.constant -= delta
            scrollView.contentOffset.y -= delta
        }

        // ヘッダービューを拡張(下スクロール)
        if delta < 0 {
            if tabTopConstraint.constant < minY && scrollView.contentOffset.y < 0 {
                if tabTopConstraint.constant - delta > minY {
                    delta = tabTopConstraint.constant - minY
                }
                tabTopConstraint.constant -= delta
                scrollView.contentOffset.y -= delta
            }
        }

        lastTabScrollViewOffset = scrollView.contentOffset
        headerDidScroll(minY: minY, maxY: maxY, currentY: tabTopConstraint.constant)
    }

    /**
     Called whenever the tabScrollView is moved up/down
     - parameters:
     - minY: The y coordinate of the lowest possible position of the top of the tabScrollView (relatively to the top of the parentView)
     - maxY: The y coordinate of the highest possible position of the top of the tabScrollView (relatively to the top of the parentView)
     - currentY: The y coordinate of the current position of the top of the tabScrollView (relatively to the top of the parentView)
     */
    open func headerDidScroll(minY: CGFloat, maxY: CGFloat, currentY: CGFloat) {
        // Change de opacity of the navBar
        guard let tabTopConstraintConstant = tabTopConstraint?.constant else {
            return
        }
        updateHeaderPositionAccordingToScrollPosition(minY: minY, maxY: maxY, currentY: tabTopConstraintConstant)
    }

    func navBarOffset() -> CGFloat {
        return (self.navigationController?.navigationBar.bounds.height ?? 0) + UIApplication.shared.statusBarFrame.height
    }

    /**
     Updates the position of the header according to the current position of the tabScrollview to create a parallax effect.
     - parameters:
     - minY: The y coordinate of the lowest possible position of the top of the tabScrollView (relatively to the top of the parentView)
     - maxY: The y coordinate of the highest possible position of the top of the tabScrollView (relatively to the top of the parentView)
     - currentY: The y coordinate of the current position of the top of the tabScrollView (relatively to the top of the parentView)
     */
    open func updateHeaderPositionAccordingToScrollPosition(minY: CGFloat, maxY: CGFloat, currentY: CGFloat) {
        if let constraint = headerTopConstraint {
            let paralaxCoef: CGFloat = 1 // i.e. if the tabScrollView goas up by 1, the header goes up by this coefficient
            let tabScrollViewTravelPercent = -(currentY-minY)/(minY-maxY)
            let headerTravelPercent = tabScrollViewTravelPercent*paralaxCoef
            let headerTargetY = headerTravelPercent*(minY-maxY)
            constraint.constant = -headerTargetY
        }
    }

}
