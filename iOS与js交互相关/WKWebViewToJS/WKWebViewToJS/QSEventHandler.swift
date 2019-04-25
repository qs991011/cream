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
    
   static func handlerJS() -> String {
        let path = Bundle.main.path(forResource: "QSEventHandler", ofType: "js")
        var handerJS = try? String(contentsOfFile: path!, encoding: .utf8)
        handerJS = handerJS?.replacingOccurrences(of: "\n", with: "")
        return handerJS ?? ""
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message")
    }
    
    
    

}
