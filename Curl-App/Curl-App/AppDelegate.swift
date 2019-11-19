//
//  AppDelegate.swift
//  Curl-App
//
//  Created by Mac on 2019/10/30.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        print("didFinishLaunchingWithOptions")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window?.rootViewController = MainTabController()
        let homeVC = HomeController()
        let homeNav = UINavigationController.init(rootViewController: homeVC)
        self.window?.rootViewController = homeNav
        self.window?.makeKeyAndVisible()
        
        // run node simulator
        let thread: Thread = Thread(target: self,
                                    selector: #selector(runNodejs),
                                    object: nil)
        thread.stackSize = 16 * 1024 * 1024
        thread.start()
        return true
    }
    
//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication,
//                     configurationForConnection connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//
//    }
    
//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication,
//                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        
//    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//
//        print("connectingSceneSession")
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        print("didDiscardSceneSessions")
//    }

    
    @objc func runNodejs(){
        if let srcPath: String = Bundle.main.path(forResource: "nodejs-project/main.js",
                                                  ofType: "") {
            let nodeArguments: [String] = ["node", srcPath]
//            print(srcPath)
//            let nodeArguments: [String] = ["node", "-e", "console.log('start')"]
            NodeRunner.startEngine(withArguments: nodeArguments)
        }
    }

}

