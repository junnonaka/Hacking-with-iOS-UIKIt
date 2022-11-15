//
//  ViewController.swift
//  Project4
//
//  Created by 野中淳 on 2022/11/13.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    var webView:WKWebView!
    var progressView:UIProgressView!
    var websites = ["apple.com","hackingwithswift.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        //Progressを表すViewを準備
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        //BarButtanItemとしてセット
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain,  target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(title: "forward", style: .plain, target: webView, action: #selector(webView.goForward))

        toolbarItems = [progressButton,spacer,backButton,forwardButton,refresh]
        navigationController?.isToolbarHidden = false
        
        //webViewに対してpath(今回はWKwebViewのEstimatedProgress)を監視するobserverをセット。optionsは新しい値がセットされたときを指定してる。
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),options: .new, context: nil)
        
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        //スワイプの許可
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped(){
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default,handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

    func openPage(action:UIAlertAction){
        
        guard let actionTitle = action.title else {return}
        guard let url = URL(string: "https://" + actionTitle) else {return}
        webView.load(URLRequest(url: url))
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    //addObserverしてプロパティが変化した時に呼ばれる。
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    //websiteのポリシーの確認？
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host{
            for website in websites {
                if host.contains(website){
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
    }

}
extension ViewController:WKNavigationDelegate{
    
}
