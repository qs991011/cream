//
//  QSEventHandler.swift
//  WKWebViewToJS
//
//  Created by 胜的钱 on 2019/4/25.
//  Copyright © 2019 胜的钱. All rights reserved.
//

import UIKit
import WebKit
class QSEventHandler: NSObject , WKScriptMessageHandler {
   weak var webview : WKWebView?
   static func handlerJS() -> String {
        let path = Bundle.main.path(forResource: "QSEventHandler", ofType: "js")
        var handerJS = try? String(contentsOfFile: path!, encoding: .utf8)
        handerJS = handerJS?.replacingOccurrences(of: "\n", with: "")
        return handerJS ?? ""
    }
    
   static func cleanHandler(handler: QSEventHandler) {
        if handler.webview != nil {
            handler.webview!.evaluateJavaScript("QSEvenetHandler.removeAllCallBacks()", completionHandler: nil)
            handler.webview!.configuration.userContentController.removeScriptMessageHandler(forName: "QSEventHandler")
        }
   
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //var dic = message.body as? [String : Any]
        guard var dic = message.body as? [String : Any] else {return}
        
        var method = dic["methodName"]
        var params = dic["params"]
        var type = dic["type"]
        if (type as? String) != nil {
            
        } else{
            var callBackID = dic["callBackID"] as? String
            if callBackID != nil {
                
            }
            
        }
    
    }

    func interact(methodName : String? , params : [String : Any]?, callback : (_ response : AnyObject)->Void?)   {
        var paramlist : [Any] = []
        
        if params != nil {
            
        }
    }
    
    
    func qs_perform(selector : Selector,params : [Any]) {
        let imp = self.method(for: selector)
        
    }
    

}
