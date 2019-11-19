//
//  MainTabController.swift
//  Curl-App
//
//  Created by Mewtwo on 2019/11/4.
//  Copyright © 2019 Ding Feng. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabbarVC()
        
//        UIImage.init(systemName: <#T##String#>)
    }
    
    private func setupTabbarVC() {
        // 文件系统
//        let terminalVC = TerminalController()
        let terminalVC = HomeController()
        terminalVC.tabBarItem = UITabBarItem.init(title: "Terminal",
                                                  image: UIImage(systemName: "chevron.left.slash.chevron.right"),
                                                  tag: 1)
        terminalVC.tabBarItem.selectedImage = UIImage(systemName: "chevron.left.slash.chevron.right.fill")
        let ternimalNav = UINavigationController.init(rootViewController: terminalVC)
        
        
        let item = UITabBarItem()
        item.title = "History"
        item.image = UIImage(systemName: "square.stack")
//        item.selectedImage =

        // 历史记录
        let historyVC = HistoryController()
        historyVC.tabBarItem = UITabBarItem.init(title: "History",
                                                 image: UIImage(systemName: "square.stack"),
                                                 tag: 0)
        historyVC.tabBarItem.selectedImage = UIImage(systemName: "square.stack.fill")
        let hisNav = UINavigationController.init(rootViewController: historyVC)
        
        // 文件系统
        let fileVC = FileDirController()
        fileVC.tabBarItem = UITabBarItem.init(title: "File",
                                                 image: UIImage(systemName: "doc.text"),
                                                 tag: 1)
        fileVC.tabBarItem.selectedImage = UIImage(systemName: "doc.text.fill")
        let fileNav = UINavigationController.init(rootViewController: fileVC)

        // 更多
        let settingVC = SettingController()
        settingVC.tabBarItem = UITabBarItem.init(title: "More",
                                                 image: UIImage(systemName: "ellipsis.circle"),
                                                 tag: 2)
        settingVC.tabBarItem.selectedImage = UIImage(systemName: "ellipsis.circle.fill")
        let settingNav = UINavigationController.init(rootViewController: settingVC)
        
        viewControllers = [ternimalNav, hisNav, fileNav, settingNav]
        
        tabBar.tintColor = .black
        
        /*
        let historyVC = HistoryController()
        historyVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history,
                                            tag: 0)
        
        let fileVC = FileDirController()
        fileVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks,
                                            tag: 0)
        
        let tabBarList = [historyVC, fileVC]
        viewControllers = tabBarList
        */
        

//        self.view.backgroundColor = UIColor.white

//        UITabBar.appearance().layer.borderWidth = 0.0
//        UITabBar.appearance().clipsToBounds = true
//
//        self.tabBar.backgroundColor = UIColor.white
//        self.tabBar.barTintColor = UIColor.white
//        self.tabBar.isTranslucent = false
//    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppTabColor.titleColorNormal],
//                                                     for:.normal)
//    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppTabColor.titleColorSelected],
//                                                         for:.selected)
//
//
//        self.addChildVC(childViewController: HistoryController(),
//                        childTitle: "First",
//                        imageName: "tab_album_n",
//                        seletedImageName: "tab_album_s")
//        self.addChildVC(childViewController: FileDirController(),
//                        childTitle: "Second",
//                        imageName: "tab_explore_n",
//                        seletedImageName: "tab_explore_s")
//        self.addChildVC(childViewController: SettingController(),
//                        childTitle: "Third",
//                        imageName: "tab_favorite_g_n",
//                        seletedImageName: "tab_favorite_b_s")
    }
    
    private func addChildVC(childViewController: UIViewController,
                            childTitle: String,
                            imageName: String,
                            seletedImageName: String)
    {
        let navigation = UINavigationController(rootViewController: childViewController)
        navigation.navigationBar.tintColor = AppColor.navigationBarTitleColor
        navigation.navigationBar.barTintColor = AppColor.navigationBarColor
        
        //let _:NSDictionary = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18)]
        let config = [NSAttributedString.Key.foregroundColor: UIColor.white,
                      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        navigation.navigationBar.titleTextAttributes = config
        
        childViewController.title = childTitle
        childViewController.tabBarItem.tag = 1
        childViewController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        childViewController.tabBarItem.selectedImage = UIImage(named: seletedImageName)?.withRenderingMode(.alwaysOriginal)
        
        self.addChild(navigation)
    }
    
    
    /// 切换黑暗模式监听回调
    /// - Parameter previousTraitCollection: 黑白对象
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        
        switch previousTraitCollection?.userInterfaceStyle {
        case .unspecified:
            print("changeMode_Theme_unspecified")

            break
            
        case .light:
            print("changeMode_Theme_light")

            break
        
        case .dark:
            print("changeMode_Theme_dark")

            break
            
        default: break
            
        }
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
