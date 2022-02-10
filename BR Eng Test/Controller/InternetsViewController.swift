//
//  InternetsViewController.swift
//  BR Eng Test
//
//  Created by Randy Varela on 1/21/22.
//  the BR webpage

import UIKit
import WebKit

class InternetsViewController: UIViewController {

    
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        view.backgroundColor = .green
        configureItems()
        
        guard let url = URL(string: "https://www.bottlerocketstudios.com") else {
            return
        }
        webView.load(URLRequest(url: url))
        
    }
    
    private func configureItems() {
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "ic_webBack"), style: .done, target: self, action: #selector(backTapped)),
            UIBarButtonItem(image: UIImage(named: "ic_webRefresh"), style: .done, target: self, action: #selector(refreshTapped)),
            UIBarButtonItem(image: UIImage(named: "ic_webForward"), style: .done, target: self, action: #selector(forwardTapped))
        ]
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    @objc private func backTapped() {
        webView.goBack()
        print("backtapped")
    }
    
    @objc private func refreshTapped() {
        webView.reload()
        print("refresh tapped")
    }
    
    @objc private func forwardTapped() {
        webView.goForward()
        print("Forward tapped")
    }
    
    
}


