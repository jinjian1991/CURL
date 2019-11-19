//
//  HistoryController.swift
//  Curl-App
//
//  Created by Mewtwo on 2019/11/4.
//  Copyright © 2019 Ding Feng. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol SwiftJavaScriptDelegate: JSExport {
    
    // js调用App的返回方法
    func popVC()
    
    // js调用App的showDic。传递Dict 参数
    func showDic(_ dict: [String: AnyObject])
    
    // js调用App方法时传递多个参数 并弹出对话框 注意js调用时的函数名
    func showDialog(_ title: String, message: String)
    
    // js调用App的功能后 App再调用js函数执行回调
    func callHandler(_ handleFuncName: String)
    
}

// 定义一个模型 该模型实现SwiftJavaScriptDelegate协议
@objc class SwiftJavaScriptModel: NSObject, SwiftJavaScriptDelegate {
    
    weak var controller: UIViewController?
    weak var jsContext: JSContext?
    
    func popVC() {
        if let vc = controller {
            DispatchQueue.main.async {
                vc.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    func showDic(_ dict: [String: AnyObject]) {
        
        print("展示信息：", dict,"= = ")
        
        // 调起微信分享逻辑
    }
    
    func showDialog(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        self.controller?.present(alert, animated: true, completion: nil)
    }
    
    func callHandler(_ handleFuncName: String) {
        
        let jsHandlerFunc = self.jsContext?.objectForKeyedSubscript("\(handleFuncName)")
        let dict = ["name": "sean", "age": 18] as [String : Any]
        let _ = jsHandlerFunc?.call(withArguments: [dict])
        
    }
}

@objc protocol GreeterJSExports: JSExport {
   func greet() -> String
   func greetMe(_ name: String) -> String
   static func getInstance() -> Greeter
   //any other properties you may want to export to JS runtime
   //var greetings: String {get set}
}

class Greeter: NSObject, GreeterJSExports {
   public func greet() -> String {
     return "Hello World!"
   }

   public func greetMe(_ name: String) -> String {
     return "Hello, " + name + "!"
   }
   class func getInstance() -> Greeter {
     return Greeter()
   }
}

class HistoryController: BaseViewController, JSExport {
    
    var jsContext: JSContext!

    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupUI()
        setupWeb()
        initializeJS()
        
        let context: JSContext = JSContext()
        let result1: JSValue = context.evaluateScript("1 + 3")
        print(result1)  // 输出4
    }
    
    // 定义协议SwiftJavaScriptDelegate 该协议必须遵守JSExport协议
    
    func initializeJS() {
        let context = JSContext()
        context?.setObject(Greeter.self, forKeyedSubscript: "Greeter" as (NSCopying & NSObjectProtocol))
        let jsValue1 = context?.evaluateScript("(function(){ var greeter = Greeter.getInstance(); return greeter.greet()})()")
        let jsValue2 = context?.evaluateScript("(function(){ var greeter = Greeter.getInstance(); return greeter.greetMe('rikesh')})()")
        print(jsValue1!)
        print(jsValue2!)
        
        
        
//        self.jsContext = JSContext()
//
//        /// Catch exception
//        self.jsContext.exceptionHandler = { context, exception in
//            if let ex = exception {
//                print("JS exception: " + ex.toString())
//            }
//        }
//
        let jsPath = Bundle.main.path(forResource: "main", ofType: "js")
        if let path = jsPath {
            do {
                let jsSourceContents = try String(contentsOfFile: path)
//                jsContext.evaluateScript(jsSourceContents)
                jsContext.evaluateScript(#"""
                console.log("++++++++++testPrint++++++++++")
                """#)
            } catch let ex {
                print(ex.localizedDescription)
            }
        }
        
        // Configurate log
//        let consoleLogObject = unsafeBitCast(self.consoleLog, to: AnyObject.self)
//        jsContext.setObject(consoleLogObject, forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol))
//        jsContext.evaluateScript("consoleLog")
    }
    
    func helloWorld() {
        if let valiableHW = jsContext.objectForKeyedSubscript("helloWorld") {
            print(valiableHW.toString())
        }
    }
    
    func jsDemo1() {
        let firstName = "zhang"
        let lastName = "san"
        if let funcFullName = jsContext.objectForKeyedSubscript("getFullName") {
            if let fullName = funcFullName.call(withArguments: [firstName, lastName]) {
                print(fullName)
            }
        }
    }
    
    
    private func setupWeb() {
    
        
        
//        let context: JSContext = JSContext()
//        let result1: JSValue = context.evaluateScript("1 + 3")
//        print(result1)  // 输出4
//
//        // 定义js变量和函数
//        context.evaluateScript("var num1 = 10; var num2 = 20;")
//        context.evaluateScript("function multiply(param1, param2) { return param1 * param2; }")
//
//        // 通过js方法名调用方法
//        let result2 = context.evaluateScript("multiply(num1, num2)")
//        print(result2 ?? "result2 = nil")  // 输出200
//
//        // 通过下标来获取js方法并调用方法
//        let squareFunc = context.objectForKeyedSubscript("multiply")
//        let result3 = squareFunc?.call(withArguments: [10, 20]).toString()
//        print(result3 ?? "result3 = nil")  // 输出200
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
        
    }
    
    private func setupNavigation() {
        b_setNavigationBarTitle("History")
//        if #available(iOS 11.0, *) {
////            navigationController?.navigationBar.prefersLargeTitles = true
//
//            navigationController?.navigationBar.prefersLargeTitles = true
//            navigationController?.navigationBar.topItem?.title = "History"
//            navigationController?.navigationItem.largeTitleDisplayMode = .automatic
//
//            let attributes = [NSAttributedString.Key.foregroundColor : UIColor.black,]
//
//            navigationController?.navigationBar.largeTitleTextAttributes = attributes
//        }
        

//        navigationItem.title = "History"
    }

}
