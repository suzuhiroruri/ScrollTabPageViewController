//
//  CAPSPageMenu+UIGestureRecognizerDelegate.swift
//  PageMenuNoStoryboardConfigurationDemo
//
//  Created by Matthew York on 3/6/17.
//  Copyright © 2017 UACAPS. All rights reserved.
//

import UIKit

extension CAPSPageMenu: UIGestureRecognizerDelegate {
    func handleMenuItemTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let tappedPoint: CGPoint = gestureRecognizer.location(in: menuScrollView)

        if tappedPoint.y < menuScrollView.frame.height {

            // Calculate tapped page
            var itemIndex: Int = 0

            itemIndex = Int(tappedPoint.x / (self.view.frame.width / CGFloat(controllerArray.count)))

            if itemIndex >= 0 && itemIndex < controllerArray.count {
                // Update page if changed
                if itemIndex != currentPageIndex {
                    startingPageForScroll = itemIndex
                    lastPageIndex = currentPageIndex
                    currentPageIndex = itemIndex
                    didTapMenuItemToScroll = true

                    // Add pages in between current and tapped page if necessary
                    let smallerIndex: Int = lastPageIndex < currentPageIndex ? lastPageIndex : currentPageIndex
                    let largerIndex: Int = lastPageIndex > currentPageIndex ? lastPageIndex : currentPageIndex

                    if smallerIndex + 1 != largerIndex {
                        for index in (smallerIndex + 1)...(largerIndex - 1) where pagesAddedDictionary[index] != index {
                            addPageAtIndex(index)
                            pagesAddedDictionary[index] = index
                        }
                    }

                    addPageAtIndex(itemIndex)

                    // Add page from which tap is initiated so it can be removed after tap is done
                    pagesAddedDictionary[lastPageIndex] = lastPageIndex
                }

                // Move controller scroll view when tapping menu item
                let xOffset: CGFloat = CGFloat(itemIndex) * self.controllerScrollView.frame.width
                self.controllerScrollView.setContentOffset(CGPoint(x: xOffset, y: self.controllerScrollView.contentOffset.y), animated: false)

                if tapTimer != nil {
                    guard let tapTimer = tapTimer else {
                        return
                    }
                    tapTimer.invalidate()
                }

                let timerInterval: TimeInterval = Double(configuration.scrollAnimationDurationOnMenuItemTap) * 0.001
                tapTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(CAPSPageMenu.scrollViewDidEndTapScrollingAnimation), userInfo: nil, repeats: false)
            }
        }
    }
}
