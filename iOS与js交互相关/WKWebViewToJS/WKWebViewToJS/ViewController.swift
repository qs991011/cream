//
//  ViewController.swift
//  WKWebViewToJS
//
//  Created by 胜的钱 on 2019/4/24.
//  Copyright © 2019 胜的钱. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler {
    
    lazy var webView : WKWebView = {
        let config = WKWebViewConfiguration()
        // 偏好设置
        config.preferences = WKPreferences()
        // 默认为0
        config.preferences.minimumFontSize = 10
        // 默认为true
        config.preferences.javaScriptEnabled = true
        // iOS上默认为NO 表示不能自动通过窗口的打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        // web 内容处理池
        config.processPool = WKProcessPool()
        //  像main中注入js
        let script = WKUserScript(source: createScript(), injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        config.userContentController = WKUserContentController()
        config.userContentController.addUserScript(script)
        
        config.userContentController.add(self, name: "QSEventHandler")
        config.userContentController.add(self, name: "GCIJS")
        let wv = WKWebView(frame: UIScreen.main.bounds,configuration: config)
        wv.navigationDelegate = self
        wv.uiDelegate = self

        return wv
    }()
    
    lazy var process : UIProgressView = {
        let v = UIProgressView(frame: self.view.bounds)
        v.backgroundColor = UIColor.black
        return v
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        self.view.addSubview(process)
        self.view.addSubview(webView)
        let url = String.init(format: "file://%@", Bundle.main.path(forResource: "test", ofType: "html") ?? "https://www.baidu.com")
        webView.load(URLRequest(url: URL(string: url)!))
    
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.view.addSubview(webView)
    }
    
    func configWebView() {
        
    }
    
    func createScript() ->String {
//        var result = "var QSEventHandler = {callNativeFunction:function(nativeMethodName,params,callBackID,callBack){window.webkit.messageHandlers.QSEventHandler.postMessage(\(1))}};"
        let result = QSEventHandler.handlerJS()
        print(result)
        return result
    }
    
    func createMainScript() -> String {
        let result = "iOSAPP={callGciFunction:function(methodname,params){return JSON.stringify(\("{age:24}"))}}"
        return result
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("页面开始加载")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("内容正在加载中")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("页面加载成功")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("页面加载失败")
    }
    // JS调用alter函数，会触发此代理方法
    // JS端调用alter时所传的数据可以通过message拿到
    // 在原生得到结果后,需要回调JS,是通过completionHandler回调
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alter = UIAlertController(title: "alert", message: message, preferredStyle: .alert)
        alter.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler()
        }))
        self.present(alter, animated: true, completion: nil)
        
    }
    
    // JS调用confirm函数，会触发此代理方法
    // JS端调用confirm时所传的数据可以通过message拿到
    // 在原生得到true/false,是通过completionHandler回调给JS
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alter = UIAlertController(title: "alert", message: message, preferredStyle: .alert)
        alter.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        alter.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        self.present(alter, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alter = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        alter.addTextField { (textfield) in
            textfield.textColor = UIColor.red
        }
        alter.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler(alter.textFields?.last?.text)
        }))
        self.present(alter, animated: true, completion: nil)
        
        
    }
    
    //
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        let request = navigationAction.request
//        print(request.url!.absoluteString)
//        var action = WKNavigationActionPolicy.allow
//        if request.url!.absoluteString.hasPrefix("https://www.baidu.com") {
//            action = .cancel
//        }
//
//        decisionHandler(action)
//
//    }
    
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        print(navigationResponse.response)
//        var response = WKNavigationResponsePolicy.allow
//        if navigationResponse.response.url!.absoluteString.hasPrefix("https://www.baidu.com") {
//            response = .cancel
//        }
//        decisionHandler(response)
//
//    }

    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
//        let body = message.body as! [String : Any]
//        print(body["params"])
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is WKWebView && keyPath == "estimatedProgress" {
            //let newProgress = change?[NSKeyValueChangeKey.newKey]
           
            process.progress = Float(webView.estimatedProgress)
        }
        
//        if !webView.isLoading {
//            UIView.animate(withDuration: 0.5) {
//                self.process.alpha = 0
//            }
//        }
    }


}

