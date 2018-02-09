//
//  BAScoutDetailAboutBenefitViewController.swift
//  ScrollTabPageViewController
//
//  Created by hir-suzuki on 2018/02/08.
//  Copyright © 2018年 EndouMari. All rights reserved.
//

import UIKit
import WebKit

class BAScoutDetailAboutBenefitViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet var aboutScoutBenefit: UINavigationItem!
    @IBOutlet var containerView: UIView!
    var webview: WKWebView? = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        aboutScoutBenefit.title = "スカウトとは"

        guard let webview: WKWebView = webview else {
            return
        }
        webview.navigationDelegate = self
        webview.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(webview)

        // 上辺の制約
        webview.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0).isActive = true
        // 下辺の制約
        webview.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0).isActive = true
        // 左辺の制約
        webview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0.0).isActive = true
        // 右辺の制約
        webview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0).isActive = true

        // 表示するWEBサイトのURLを設定します。
        guard let url = URL(string: "https://www.baitoru.com/info/scout/icon_explanation.html") else {
            return
        }
        let urlRequest = URLRequest(url: url)
        // webViewで表示するWEBサイトの読み込みを開始します。
        webview.load(urlRequest)
    }

    @IBAction func tapDismissButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func tapReloadButton(_ sender: UIBarButtonItem) {
        webview?.reload()
    }

}
