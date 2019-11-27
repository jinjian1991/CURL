//
//  RequestTableController.swift
//  Curl-App
//
//  Created by Mewtwo on 2019/11/21.
//  Copyright © 2019 Ding Feng. All rights reserved.
//

import UIKit

class RequestTableController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let tableFrame = CGRect.init(x: 18,
                                     y: 0,
                                     width: UIScreen.main.bounds.size.width - 18*2,
                                     height: UIScreen.main.bounds.size.height)
        tableView.frame = tableFrame
        self.view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MultiLineTextInputTableViewCell", bundle: nil), forCellReuseIdentifier: "MultiLineTextInputTableViewCell")
        tableView.keyboardDismissMode = .onDrag
    }

//    private lazy var tableView: UITableView = {
//        let tableFrame = CGRect.init(x: 18,
//                                     y: 0,
//                                     width: UIScreen.main.bounds.size.width - 18*2,
//                                     height: UIScreen.main.bounds.size.height)
//
//        let table = UITableView.init(frame: tableFrame,
//                                     style: .grouped)
//        table.delegate = self
//        table.dataSource = self
//
//        table.backgroundColor = UIColor.LightTheme.backgroundColor
//        table.tableFooterView = UIView()
//        table.separatorStyle = .none
//
//        return table
//    }()
}



//extension RequestController {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MultiLineTextInputTableViewCell", for: indexPath) as! MultiLineTextInputTableViewCell
//        cell.titleLabel?.text = "Multi line cell"
//        cell.textString = "Test String\nAnd another string\nAnd another"
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44.0
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}
