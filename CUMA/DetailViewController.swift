//
//  DetailViewController.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/10/25.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //webView.navigationDelegate = self
        
//        let urlString = "https://www.google.com/"
//        let myURL = URL(string: urlString)
//        let myRequest = URLRequest(url: myURL!)
        
       // webView.load(myRequest)
    }

}

extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.title", completionHandler: {(result, error) -> Void in
            if let html = result as? String {
                print(html)
            }
        })
    }
}
