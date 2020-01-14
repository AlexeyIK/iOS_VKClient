//
//  LoginWKViewController.swift
//  iOS_UI_practice1
//
//  Created by Alex on 13/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit
import Alamofire
import WebKit

class LoginWKViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    let apiID = "7280637"
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [URLQueryItem(name: "client_id", value: apiID),
                              URLQueryItem(name: "display", value: "mobile"),
                              URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                              URLQueryItem(name: "scope", value: "262150"),
                              URLQueryItem(name: "response_type", value: "token"),
                              URLQueryItem(name: "v", value: "5.103")]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginWKViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html",
            let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment.components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        Session.shared.token = params["access_token"] ?? ""
        Session.shared.userId = params["user_id"] ?? ""
        
        print(params)
        
        decisionHandler(.cancel)
    }
}
