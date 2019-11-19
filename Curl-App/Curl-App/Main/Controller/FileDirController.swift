//
//  FileDirController.swift
//  Curl-App
//
//  Created by Mewtwo on 2019/11/4.
//  Copyright © 2019 Ding Feng. All rights reserved.
//

import UIKit

class FileDirController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let app = AppVariable.read() {
            print("app_app:\(app)")
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
        
    }
    
    private func setupNavigation() {
        b_setNavigationBarTitle("Files")
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
