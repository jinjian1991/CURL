//
//  TestController.swift
//  Curl-App
//
//  Created by Mewtwo on 2019/11/26.
//  Copyright © 2019 Ding Feng. All rights reserved.
//

import UIKit

class TestController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "TestVC"
        
        
        myTable.register(UINib(nibName: "MultiLineTextInputTableViewCell",
                               bundle: nil),
                         forCellReuseIdentifier: "MultiLineTextInputTableViewCell")
        myTable.keyboardDismissMode = .onDrag
        self.view.addSubview(myTable)
    }
    
    private lazy var myTable: UITableView = {
        let table = UITableView.init(frame: CGRect.zero,
                                     style: .grouped)
        table.frame = self.view.frame
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultiLineTextInputTableViewCell", for: indexPath) as! MultiLineTextInputTableViewCell
        cell.titleLabel?.text = "Multi line cell"
        cell.textString = "Test String\nAnd another string\nAnd another"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

}
