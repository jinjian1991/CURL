//
//  RequestController.swift
//  Curl-App
//
//  Created by Mewtwo on 2019/11/9.
//  Copyright © 2019 Ding Feng. All rights reserved.
//

import UIKit

extension UIView {
    /**
     圆角的大小：corderSize，
     自动布局下切记一定设置imageSize
     */
    func cornerSets(corderSize: CGFloat, viewSize: CGSize) {
        bounds = CGRect.init(origin: CGPoint.zero, size: viewSize)
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize.init(width: 20, height: 5))
        let maskLayer = CAShapeLayer.init()
        maskLayer.path = maskPath.cgPath;
        maskLayer.frame = bounds
        layer.mask = maskLayer
    }
}

extension UITableViewCell {
    public var disclosureIndicatorColor: UIColor? {
        get {
            return arrowButton?.tintColor
        }
        set {
            var image = arrowButton?.backgroundImage(for: .normal)
            image = image?.withRenderingMode(.alwaysTemplate)
            arrowButton?.tintColor = newValue
            arrowButton?.setBackgroundImage(image, for: .normal)
        }
    }

    public func updateDisclosureIndicatorColorToTintColor() {
        self.disclosureIndicatorColor = self.window?.tintColor
    }

    private var arrowButton: UIButton? {
        var buttonView: UIButton?
        self.subviews.forEach { (view) in
            if view is UIButton {
                buttonView = view as? UIButton
                return
            }
        }
        return buttonView
    }
    
    func applyConfig(for indexPath: IndexPath, numberOfCellsInSection: Int) {
        switch indexPath.row {
        case numberOfCellsInSection - 1:
            // This is the case when the cell is last in the section,
            // so we round to bottom corners
            self.roundCorners(.bottom, radius: 15)
            
            // However, if it's the only one, round all four
            if numberOfCellsInSection == 1 {
                self.roundCorners(.all, radius: 15)
            }
            
        case 0:
            // If the cell is first in the section, round the top corners
            self.roundCorners(.top, radius: 15)
            
        default:
            // If it's somewhere in the middle, round no corners
            self.roundCorners(.all, radius: 0)
        }
        
        if indexPath.row != 0 {
            let bottomBorder = CALayer()
            
            bottomBorder.frame = CGRect(x: 16.0,
                                        y: 0,
                                        width: self.contentView.frame.size.width - 16,
                                        height: 0.2)
            bottomBorder.backgroundColor = UIColor(white: 0.8, alpha: 1.0).cgColor
            self.contentView.layer.addSublayer(bottomBorder)
        }
    }
}


class HomeController: BaseViewController, UITextViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    /// 传入 main.js 调用命令
    public var curl: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupUI()
    }
    
    // MARK: IBAction
    /// CURL 方法
    private func runCURLAction() {
//        let url = "http://172.16.0.30:3000/curl"
//        let url = "http://localhost:3000/curl"
        let url = "http://127.0.0.1:3000/curl"
        let curl = """
            curl -X POST \
              https://httpbin.org/post \
              -H 'cache-control: no-cache' \
              -H 'content-type: application/json' \
              -H 'postman-token: f4db96e4-7b9a-26ee-1bc1-3ef236338235' \
              -d '{
                "key": "value"
            }'
        """
        
        let param = ["curl": curl]
        
        let http = SwiftHttp()
        http.POST(url, body: param)
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
    
    @objc func navigationItemTapAction( _aItem: UIBarButtonItem) {
        if _aItem.tag == 0 {
            // scan action
            scanQRCodeAction()
        } else {
            // run action
            runCURLAction()
        }
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
        
        
        cell?.backgroundColor = .white
        
//        cell?.textLabel?.text = "Pull Requests"
//        cell?.detailTextLabel?.text = "Post Get Delete"
//        cell?.imageView?.image = UIImage.init(systemName: "plus.square")
//        cell?.imageView?.image = UIImage.init(named: "icon_new")
        
        cell?.textLabel?.textColor = .black
        cell?.applyConfig(for: indexPath,
                          numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        cell?.disclosureIndicatorColor = .red
        cell?.updateConstraints()
        
        if indexPath.section == 0 {
            cell?.textLabel?.text = "New"
        } else if indexPath.section == 1 {
            cell?.textLabel?.text = TableViriables.kTemplateTitles[indexPath.row]
//            cell?.textLabel?.backgroundColor = UIColor.systemBlue
            cell?.textLabel?.textColor = .systemBlue
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .lightGray
        cell?.selectedBackgroundView = bgColorView
 
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let requestVC = RequestController()
        switch indexPath.section {
            case 0:
                requestVC.navigationTitle = "New"
            case 1:
                requestVC.navigationTitle = TableViriables.kTemplateTitles[indexPath.row]
            case 2:
                requestVC.navigationTitle = "Recent"
            default:
                requestVC.navigationTitle = ""
        }
        navigationController?.pushViewController(requestVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0,
                                                        y: 0,
                                                        width: tableView.frame.width,
                                                        height: 50))
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.frame = CGRect.init(x: 0,
                                       y: 0,
                                       width: headerView.frame.width,
                                       height: headerView.frame.height)
        titleLabel.text = TableViriables.kHeaderTitles[section]
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 22)!
        titleLabel.textColor = .black
        headerView.addSubview(titleLabel)
        
        let subTitleLabel = UILabel()
        subTitleLabel.frame = CGRect.init(x: 0,
                                       y: 0,
                                       width: headerView.frame.width,
                                       height: headerView.frame.height)
        subTitleLabel.textAlignment = .right
        subTitleLabel.font = UIFont.systemFont(ofSize: 14.0)
        subTitleLabel.textColor = .black
        headerView.addSubview(subTitleLabel)
        if section == 2 {
            subTitleLabel.text = "No Datas"
        }
        
        headerView.backgroundColor = .clear

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        
        switch section {
        case 0:
            rows = 1
        case 1:
            rows = 4
        default:
            rows = 0
        }
        
        return rows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViriables.kSection
    }
    
    // MARK: UI
    
    private func setupNavigation() {
        b_setNavigationBarTitle("CURL")
        
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
    
    private func setupUI() {
//        self.view.backgroundColor = UIColor.white
//        self.view.addSubview(scrollView)
        // 二维码扫描按钮
//        self.view.addSubview(urlTitleLabel)
//        self.view.addSubview(urlTextView)
        
        self.view.addSubview(myTable)
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
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.frame = CGRect.init(x: 0,
                                   y: 0,
                                   width: UIScreen.main.bounds.size.width,
                                   height: UIScreen.main.bounds.size.height)
        scroll.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width,
                                         height: UIScreen.main.bounds.size.height*2)
        scroll.delegate = self
//        scroll.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        scroll.backgroundColor = .white
        return scroll
    }()
    
    private lazy var myTable: UITableView = {
        let tableFrame = CGRect.init(x: 18,
                                     y: 0,
                                     width: UIScreen.main.bounds.size.width - 18*2,
                                     height: UIScreen.main.bounds.size.height - 0)
        
        let table = UITableView.init(frame: tableFrame,
                                     style: .grouped)
        table.delegate = self
        table.dataSource = self

        table.backgroundColor = UIColor.LightTheme.backgroundColor
        table.tableFooterView = UIView()
        table.separatorStyle = .none//UITableViewCellSeparatorStyleNone
        
        
        return table
    }()
    
}

struct TableViriables {
    static var kHeaderTitles = ["New", "Template", "Recent"]
    static var kRows = [1, 2, 10]
    static var kSection: Int = 3
    static var kTemplateTitles = ["POST", "GET", "PUT", "DELETE"]
}
