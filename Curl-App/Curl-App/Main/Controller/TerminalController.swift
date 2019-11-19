//
//  TerminalController.swift
//  Curl-App
//
//  Created by Mewtwo on 2019/11/5.
//  Copyright © 2019 Ding Feng. All rights reserved.
//

import UIKit
import JavaScriptCore
//import WebKit


@objc protocol JSBridgeDelegate: JSExport {
    
    // js调用App的返回方法
    func app_popAlert()
}

class TerminalController: BaseViewController, UITextViewDelegate {
    
    /// 传入 main.js 调用命令
    public var curl: String!
    
    public var jsContext: JSContext!
    
    var guessedNumbers = [5, 37, 22, 18, 9, 42]
    
    // MARK: Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupUI()
        setupTest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(TerminalController.handleDidReceiveLuckyNumbersNotification(notification:)),
                                               name: NSNotification.Name("didReceiveRandomNumbers"),
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name("didReceiveRandomNumbers"),
                                                  object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initializeJS()
//        helloWorld()
//        jsDemo1()
        
        jsDemo3()
        
//        transValueDemo()
    }
    
    func initializeJS() {
        self.jsContext = JSContext()
        
        // Add an exception handler.
        self.jsContext.exceptionHandler = { context, exception in
            if let exc = exception {
                print("!!!!!!!!!!JS Exception:", exc.toString() as Any)
                return
            }
        }
        
        // Specify the path to the jssource.js file.
        let folderName = "nodejs-project"
//        let fileName = "jssource.js"
        let fileName   = "main.js"
        let jsPath = Bundle.main.resourcePath! + "/\(folderName)/\(fileName)"
        print("js_path:=", jsPath )
        
//        if let jsSourcePath = Bundle.main.path(forResource: "jssource", ofType: "js")
        
        do {
           // Load its contents to a String variable.
           let jsSourceContents = try String(contentsOfFile: jsPath)
           // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.
           self.jsContext.evaluateScript(jsSourceContents)
        } catch {
           print("jsSourceContents_error:\(error.localizedDescription)")
        }
        
//
//        let consoleLogObject = unsafeBitCast(self.consoleLog, to: AnyObject.self)
//        self.jsContext.setObject(consoleLogObject, forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol))
//        _ = self.jsContext.evaluateScript("consoleLog")
    }
    
    // demo
    let jsDataHandler: @convention(block) (String) -> Void = { statusCode in
        
        print("jsToswift_pushData: \(statusCode)")
        
        
        NotificationCenter.default.post(name: NSNotification.Name("didReceiveRandomNumbers"),
                                        object: "testjsDataHandler")
        print("luckyNumbers_Type: \(type(of: "testjsDataHandler"))")
        
//        let alertPrompt = UIAlertController(title: "jsToswift_pushData",
//                                                    message: statusCode,
//                                                    preferredStyle: .alert)
//        let confirmAction = UIAlertAction(title: "Confirm",
//                                          style: UIAlertAction.Style.default,
//                                          handler:nil)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
//
//        alertPrompt.addAction(confirmAction)
//        alertPrompt.addAction(cancelAction)
        
//        present(alertPrompt, animated: true, completion: nil)
//        TerminalController.present(alertPrompt, animated: true, completion: nil)
        
//        self.jsAlertDemo()
//        jsAlertDemo()
    }
    
    let luckyNumbersHandler: @convention(block) ([Int]) -> Void = { luckyNumbers in
        NotificationCenter.default.post(name: NSNotification.Name("didReceiveRandomNumbers"),
                                        object: luckyNumbers)
        print("luckyNumbers_Type: \(type(of: luckyNumbers))")
    }
    
    private let consoleLog: @convention(block) (String) -> Void = { logMessage in
        print("\nJS Console:", logMessage)
        print("\nJS Console_class:", type(of: logMessage))
    }
    
    @objc func handleDidReceiveLuckyNumbersNotification(notification: Notification) {
        if let luckyNumbers = notification.object as? [Int] {
            print("\n\nLucky numbers:", luckyNumbers, "   Your guess:", guessedNumbers, "\n")
     
            var correctGuesses = 0
            for number in luckyNumbers {
                if let _ = self.guessedNumbers.index(of: number) {
                    print("You guessed correctly:", number)
                    correctGuesses += 1
                }
            }
     
            print("Total correct guesses:", correctGuesses)
     
            if correctGuesses == 6 {
                print("You are the big winner!!!")
            }
        }
        
        print("notification_obj: \(notification.object)")
        
    }
    
    func jsDemo3() {
        let luckyNumbersObject = unsafeBitCast(self.luckyNumbersHandler, to: AnyObject.self)

        self.jsContext.setObject(luckyNumbersObject,
                                 forKeyedSubscript: "handleLuckyNumbers" as (NSCopying & NSObjectProtocol)?)

    
        _ = self.jsContext.evaluateScript("handleLuckyNumbers")
        
        if let functionGenerateLuckyNumbers = self.jsContext.objectForKeyedSubscript("generateLuckyNumbers") {
            _ = functionGenerateLuckyNumbers.call(withArguments: nil)
        }
    }
    
    func transValueDemo() {
        let curlObject = unsafeBitCast(self.jsDataHandler, to: AnyObject.self)
        self.jsContext.setObject(curlObject,
                                 forKeyedSubscript: "jsToswift_pushData" as (NSCopying & NSObjectProtocol)?)
        _ = self.jsContext.evaluateScript("jsToswift_pushData")
    }
    
    func helloWorld() {
        if let variableHelloWorld = self.jsContext.objectForKeyedSubscript("helloWorld")
        {
            print(variableHelloWorld.toString() as Any)
        }
    }
    
    func jsDemo1() {
        let firstname = "Kim"
        let lastname  = "Ken"
        
        if let functionFullname = self.jsContext.objectForKeyedSubscript("getFullname")
        {
            if let fullname = functionFullname.call(withArguments: [firstname, lastname])
            {
                print("fullname: \(fullname.toString() as Any)")
            }
        }
    }
    
    func mainJSDemo() {
        if let testFuckPrint = self.jsContext.objectForKeyedSubscript("testPrint")
        {
            print("testPrint: \(testFuckPrint.toString() as Any)")
        }
        
    }
    
    
    public func jsAlertDemo() {
        let title = "title"
        let message = "message"
        
        if let functionAlert = self.jsContext.objectForKeyedSubscript("demoAlert")
        {
            if let alert = functionAlert.call(withArguments: [title, message])
            {
                print("alert_demo: \(alert)")
            }
        }
    }
    
    // MARK: IBAction
    
    @objc func navigationItemTapAction( _aItem: UIBarButtonItem) {
        if _aItem.tag == 0 {
            // scan action
            scanQRCodeAction()
        } else {
            // run action
            runCURLAction()
        }
    }
    
    /// CURL 方法
    private func runCURLAction() {
//        let luckyNumbersObject = unsafeBitCast(self.luckyNumbersHandler, to: AnyObject.self)
//
//            self.jsContext.setObject(luckyNumbersObject,
//                                     forKeyedSubscript: "handleLuckyNumbers" as (NSCopying & NSObjectProtocol)?)
//
//
//            _ = self.jsContext.evaluateScript("handleLuckyNumbers")
        
//        let curlObject = unsafeBitCast(self.jsDataHandler, to: AnyObject.self)
//        self.jsContext.setObject(curlObject,
//                                 forKeyedSubscript: "jsToswift_pushData" as (NSCopying & NSObjectProtocol)?)
//        _ = self.jsContext.evaluateScript("jsToswift_pushData")
    }
    
    /// 扫描二维码调起方法
    private func scanQRCodeAction () {
        let qrController = QRScannerController()
        qrController.callback = { (scanResult) -> Void in
            self.urlTextView.text = scanResult
            self.curl = scanResult
            AppManager.shared.curl = scanResult
            
            let app = AppVariable(curl: scanResult)
            app.write()
        }
        navigationController?.present(qrController,
                                      animated: true,
                                      completion:
        {
         
        })
    }
    
    // MARK: UI
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
        // 二维码扫描按钮
//        let scanButton = UIButton.init(type: .system)
//        scanButton.frame = CGRect.init(x: UIScreen.main.bounds.size.width - 70,
//                                       y: 200,
//                                       width: 50,
//                                       height: 50)
//        scanButton.setImage(UIImage.init(systemName: "viewfinder.circle"),
//                            for: .normal)
//        scanButton.setImage(UIImage.init(systemName: "viewfinder.circle.fill"),
//                            for: .highlighted)
//        view.addSubview(scanButton)
//        scanButton.addTarget(self,
//                             action: #selector(scanQRCodeAction),
//                             for: .touchUpInside)
        
        self.view.addSubview(urlTitleLabel)
        self.view.addSubview(urlTextView)
    }
    
    private func setupNavigation() {
        b_setNavigationBarTitle("Terminal")
        
        let scanItem = UIBarButtonItem.init(image: UIImage.init(systemName: "viewfinder.circle"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(navigationItemTapAction(_aItem:)))
        let runItem = UIBarButtonItem.init(image: UIImage.init(systemName: "command"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(navigationItemTapAction(_aItem:)))
        scanItem.tintColor = UIColor.black
        runItem.tintColor = UIColor.black
        scanItem.tag = 0
        runItem.tag  = 1
        navigationItem.rightBarButtonItems = [runItem, scanItem]
    }
    
    // FIXME: 删除测试用例
    private func setupTest() {
        let testButton = UIButton.init(type: .system)
        testButton.backgroundColor = .black
        testButton.frame = CGRect.init(x: 30,
                                       y: 400,
                                       width: UIScreen.main.bounds.size.width - 30*2,
                                       height: 45)
        testButton.layer.cornerRadius = 8.0
        testButton.setTitle("Post", for: .normal)
        testButton.setTitleColor(.white, for: .normal)
        self.view.addSubview(testButton)
        testButton.addTarget(self,
                             action: #selector(testAction),
                             for: .touchUpInside)
    }
    
    
    /// IBAction
    @objc func testAction() {
        
//        mainJSDemo()
        
//        app_popAlert()
    }
    
    func app_popAlert() {
        let alertPrompt = UIAlertController(title: "app_popAlert",
                                                    message: "",
                                                    preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm",
                                          style: UIAlertAction.Style.default,
                                          handler:nil)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    
    // MARK: UITextView Delegate
    func textView(_ textView: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
        let resultRange = text.rangeOfCharacter(from: CharacterSet.newlines, options: .backwards)
        if text.count == 1 && resultRange != nil {
            textView.resignFirstResponder()
            // Do any additional stuff here
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        curl = textView.text
    }
    
    // MARK: Lazy Load
    private lazy var urlTextView: UITextView = {
        let EdgeX = urlTitleLabel.frame.origin.x
        
        
        let urlText = UITextView()
        urlText.delegate = self
        urlText.frame = CGRect.init(x: EdgeX + 35/*12*/,
                                    y: (self.navigationController?.navigationBar.frame.size.height)! + 45,
                                    width: UIScreen.main.bounds.size.width - 12 - EdgeX - 35,
                                    height: 45)
        urlText.backgroundColor = #colorLiteral(red: 0.9332318902, green: 0.9333917499, blue: 0.933221817, alpha: 1)
        urlText.layer.cornerRadius = 10.0
        urlText.returnKeyType = .done
        
        if let app = AppVariable.read() {
            urlText.text = app.curl
        }
        
        return urlText
    }()
    
    private lazy var urlTitleLabel: UILabel = {
        let urlLabel = UILabel()
        urlLabel.frame = CGRect.init(x: 12,
                                     y: (self.navigationController?.navigationBar.frame.size.height)! + 45,
                                     width: 35,
                                     height: 45)
        urlLabel.text = "curl"
        urlLabel.textAlignment = .left
        urlLabel.textColor = #colorLiteral(red: 0.5842481256, green: 0.5843515396, blue: 0.5842416286, alpha: 1)
        
        return urlLabel
    }()
    
//    private lazy var webView: WKWebView = {
//        let web = WKWebView()
//
//
//        return web
//    }()
}
