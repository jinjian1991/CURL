//
//  SettingController.swift
//  Curl-App
//
//  Created by Mewtwo on 2019/11/4.
//  Copyright © 2019 Ding Feng. All rights reserved.
//

import UIKit

class SettingController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
        
    }
    
    private func setupNavigation() {
        b_setNavigationBarTitle("More")
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
