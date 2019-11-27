//
//  BaseViewController.swift
//  Curl-App
//
//  Created by Mewtwo on 2019/11/4.
//  Copyright © 2019 Ding Feng. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var hideNavigationBarBottomLine = false
    var isTranslucentNavigationBar  = true
    var navTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        b_setupNavigation()
        b_setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: UI
    
    func b_setupUI() {
        self.view.backgroundColor = UIColor.LightTheme.backgroundColor
    }
    
    func b_setupNavigation() {
        if hideNavigationBarBottomLine {
            navigationController?.navigationBar.setValue(true, forKeyPath: "hidesShadow")
        }
        
        if isTranslucentNavigationBar {
            navigationController?.navigationBar.isTranslucent = true
        }
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
//            navigationController?.navigationBar.topItem?.title = "Terminal"
            navigationController?.navigationBar.topItem?.title = navTitle
            navigationController?.navigationItem.largeTitleDisplayMode = .automatic

            let attributes = [NSAttributedString.Key.foregroundColor : UIColor.black,]

            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        } else {
//            navigationController?.navigationBar.topItem?.title = "Terminal"
            navigationController?.navigationBar.topItem?.title = navTitle
        }
        
    }
    
    /// Base Method: Hide navigationbar bottom line
    public func b_hideNavigationBarBottomLine () {
        navigationController?.navigationBar.setValue(true, forKeyPath: "hidesShadow")
    }

    public func b_setNavigationBarTitle(_ navTitle: String) {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.topItem?.title = navTitle
        } else {
            navigationItem.title = navTitle
        }
    }

    

}
