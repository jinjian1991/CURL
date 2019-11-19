//
//  RequestController.swift
//  Curl-App
//
//  Created by Mewtwo on 2019/11/19.
//  Copyright © 2019 Ding Feng. All rights reserved.
//

import UIKit

class RequestController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    public var navigationTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupNavigation()
        setupUI()
    }
    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .value1,
                                   reuseIdentifier: cellID)
        }
        
        cell?.accessoryType = .disclosureIndicator
        
        cell?.applyConfig(for: indexPath,
                          numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        
        
        cell?.backgroundColor = .white
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return urlView
        
//        let headerView = UIView.init(frame: CGRect.init(x: 0,
//                                                        y: 0,
//                                                        width: tableView.frame.width,
//                                                        height: 50))
//        headerView.backgroundColor = .clear
//
//
//        // Title Label
//        let titleLabel = UILabel()
//        titleLabel.frame = CGRect.init(x: 0,
//                                       y: 0,
//                                       width: headerView.frame.width,
//                                       height: 45)
//        titleLabel.text = TableViriables.kHeaderTitles[section]
//        titleLabel.textAlignment = .left
//        titleLabel.text = "URL"
//        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 22)!
//        titleLabel.textColor = .black
//        titleLabel.backgroundColor = .clear
//        headerView.addSubview(titleLabel)
//
//
//        let urlField = UITextField()
//        urlField.frame = CGRect(x: 0,
//                                y: titleLabel.frame.maxY,
//                                width: headerView.frame.width,
//                                height: 45)
//        urlField.delegate = self as? UITextFieldDelegate
//        urlField.placeholder = "The request url"
//        urlField.layer.cornerRadius = 10.0
//        urlField.layer.borderWidth = 0.5
//        urlField.layer.borderColor = UIColor.clear.cgColor
//        urlField.layer.masksToBounds = true
//        urlField.backgroundColor = .white
//        urlField.clearButtonMode = .whileEditing
//
//        let leftView = UIView()
//        leftView.frame = CGRect(x: 0, y: 0, width: 10, height: urlField.frame.size.height)
//        leftView.backgroundColor = urlField.backgroundColor
//        urlField.leftView = leftView
//        urlField.leftViewMode = .always;
//
//        headerView.addSubview(urlField)
//
//        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerHeight = 0
        if section == 0 {
            headerHeight = 120
        }
        return CGFloat(headerHeight)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // MARK: UI
    func setupNavigation() {
        navigationItem.title = navigationTitle
    }
    
    func setupUI() {
        
        
        self.view.addSubview(myTable)
    }
    
    // MARK: Touch Delegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: UITextField Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.endEditing(true)
    }
    
    // MARK: Lazy Load
    private lazy var myTable: UITableView = {
        let tableFrame = CGRect.init(x: 18,
                                     y: 0,
                                     width: UIScreen.main.bounds.size.width - 18*2,
                                     height: UIScreen.main.bounds.size.height)
        
        let table = UITableView.init(frame: tableFrame,
                                     style: .grouped)
        table.delegate = self
        table.dataSource = self
        
        table.backgroundColor = UIColor.LightTheme.backgroundColor
        table.tableFooterView = UIView()
        table.separatorStyle = .none//UITableViewCellSeparatorStyleNone
        
        return table
    }()
    
//    private lazy var urlField: UITextField = {
//        let urlField = UITextField()
//        urlField.delegate = self as? UITextFieldDelegate
//
//        return urlField
//    }()
    
    private lazy var urlView: UIView = {
        let headerView = UIView.init(frame: CGRect.init(x: 0,
                                                        y: 0,
                                                        width: myTable.frame.width,
                                                        height: 50))
        headerView.backgroundColor = .clear

        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.frame = CGRect.init(x: 0,
                                       y: 0,
                                       width: headerView.frame.width,
                                       height: 45)
        titleLabel.text = TableViriables.kHeaderTitles[0]
        titleLabel.textAlignment = .left
        titleLabel.text = "URL"
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 22)!
        titleLabel.textColor = .black
        titleLabel.backgroundColor = .clear
        headerView.addSubview(titleLabel)
        
        
        let urlField = UITextField()
        urlField.frame = CGRect(x: 0,
                                y: titleLabel.frame.maxY,
                                width: headerView.frame.width,
                                height: 45)
        urlField.delegate = self as? UITextFieldDelegate
        urlField.placeholder = "The request url"
        urlField.layer.cornerRadius = 10.0
        urlField.layer.borderWidth = 0.5
        urlField.layer.borderColor = UIColor.clear.cgColor
        urlField.layer.masksToBounds = true
        urlField.backgroundColor = .white
        urlField.clearButtonMode = .whileEditing
        
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 10, height: urlField.frame.size.height)
        leftView.backgroundColor = urlField.backgroundColor
        urlField.leftView = leftView
        urlField.leftViewMode = .always;

        headerView.addSubview(urlField)

        return headerView
    }()
    
    private lazy var headersView: UIView = {
        let headerV = UIView()
        
        return headerV
    }()
    
    private lazy var bodysView: UIView = {
        let bodyV = UIView()
        
        return bodyV
    }()
    
    private lazy var paramsView: UIView = {
        let paramV = UIView()
        
        return paramV
    }()
    
    /*
     curl -X POST \
       https://httpbin.org/post \
       -H 'cache-control: no-cache' \
       -H 'content-type: application/json' \
       -H 'postman-token: f4db96e4-7b9a-26ee-1bc1-3ef236338235' \
       -d '{
         "key": "value"
     }'
     */
}
