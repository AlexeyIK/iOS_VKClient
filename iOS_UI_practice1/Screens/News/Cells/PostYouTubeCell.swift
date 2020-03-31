//
//  PostYouTubeCell.swift
//  iOS_UI_practice1
//
//  Created by Alex on 21/03/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit
import WebKit

class PostYouTubeCell: UITableViewCell, WKNavigationDelegate {

    @IBOutlet var wk: WKWebView!
    @IBOutlet weak var placeholder: UIView!
    @IBOutlet weak var videoframe: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playVideo))
        placeholder.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        placeholder.isHidden = false
//    }
    
    // MARK: WebView delegate for videos
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        UIView.animate(withDuration: 2.0) {
//            self.placeholder.isHidden = true
//        }
//    }
    
    @objc func playVideo(sender: UIView) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.placeholder.alpha = 0.0
        }, completion: { _ in
            self.placeholder.isHidden = true
        })
    }

}
