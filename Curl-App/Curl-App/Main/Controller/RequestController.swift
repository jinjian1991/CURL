//
//  RequestController.swift
//  Curl-App
//
//  Created by Mewtwo on 2019/11/19.
//  Copyright © 2019 Ding Feng. All rights reserved.
//

import UIKit

//extension UITextView {
//    func adjustUITextViewHeight() {
//        self.translatesAutoresizingMaskIntoConstraints = true
//        self.sizeToFit()
//        self.isScrollEnabled = false
//    }
//}

//MARK: - UITableViewDataSource
//extension RequestController {
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    override func tableviewint
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MultiLineTextInputTableViewCell", for: indexPath) as! MultiLineTextInputTableViewCell
//        cell.titleLabel?.text = "Multi line cell"
//        cell.textString = "Test String\nAnd another string\nAnd another"
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44.0
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}

class RequestController: BaseViewController, UITableViewDelegate, UITableViewDataSource, MultiLineTextInputTableViewCellDelegate {
    public var navigationTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
//        setupUI()
        
//        myTable.estimatedRowHeight = 44.0
//        myTable.rowHeight = UITableView.automaticDimension
        
        myTable.register(UINib(nibName: "MultiLineTextInputTableViewCell", bundle: nil),
                         forCellReuseIdentifier: "MultiLineTextInputTableViewCell")
        myTable.keyboardDismissMode = .onDrag
        
//        myTable.frame = self.view.frame
        
        let tableFrame = CGRect.init(x: 18,
                        y: 0,
                        width: UIScreen.main.bounds.size.width - 18*2,
                        height: UIScreen.main.bounds.size.height - 0)
        myTable.frame = tableFrame
        self.view.addSubview(myTable)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            // TODO: Fix other iOS devices bottom frame
            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
                self.view.frame.origin.y -= 50
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MultiLineTextInputTableViewCell", for: indexPath) as! MultiLineTextInputTableViewCell
        cell.multiLineTextViewCellDelegate = self as? MultiLineTextInputTableViewCellDelegate
//        cell.titleLabel?.text = "Multi line cell"
//        cell.textString = "Test String\nAnd another string\nAnd another"
//        return cell

        
//        let cellID = "cellIdentifier"
//        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
//        if cell == nil {
//            cell = MultiLineTextInputTableViewCell(style: .value1,
//                                   reuseIdentifier: cellID)
//        }

//        cell?.accessoryType = .disclosureIndicator
        cell.accessoryType = .none

        cell.applyConfig(for: indexPath,
                          numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))


        cell.backgroundColor = .white
        cell.tag = indexPath.section

//        let inputView = UITextView()
//        inputView.delegate = self as! UITextViewDelegate
//        inputView.frame = CGRect(x: 5,
//                                 y: 5,
//                                 width: (cell.frame.size.width),
//                                 height: (cell.frame.size.height) - 10)
//            /*cell!.frame*/
////        inputView.backgroundColor = .red
//        inputView.font = UIFont.systemFont(ofSize: 15.0)
//
////        inputView.adjustUITextViewHeight()
//        inputView.tag = indexPath.section
//
//        let sizeThatShouldFitTheContent = inputView.sizeThatFits(inputView.frame.size)
//        let height = sizeThatShouldFitTheContent.height
//
//        cell.contentView.addSubview(inputView)
        
        cell.textString = "Test"



        return cell
 
    }
    
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            case 0:
                return urlView
            case 1:
                return bodysView
            case 2:
                return bodysView
            default:
                return headersView
        }


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
            headerHeight = 120 + 40
        } else if section == 1 {
            headerHeight = 50
        } else if section == 2 {
            headerHeight = 50
        }
        return CGFloat(headerHeight)
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func multiLineTextInputTextViewCell(text: String, section: Int) {
        print("multiLineTextInputTextViewCell_String: \(text), section: \(section)")
    }
    
    // MARK: UI
    func setupNavigation() {
        navigationItem.title = navigationTitle
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func setupUI() {
        
        
//        self.view.addSubview(myTable)
    }
    
    // MARK: Touch Delegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: UITextField Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.endEditing(true)
    }
    
    // MARK: UITextView Delegate
//    func textViewDidChange(_ textView: UITextView) {
        // TODO: 只能输入英语
        
//        let inputModel = textView.textInputMode?.primaryLanguage
//        if inputModel == "zh-Hans" {
//            let selectedRange = textView.markedTextRange
//            let position = textView.position(from: selectedRange!.start,
//                                             offset: 0)
//            if position == nil {
//
//            }
//        }
//    }
    
//    func textViewDidEndEditing(_ textView: UITextView) {
////        print("textViewEndEditing_text: \(String(describing: textView.text))")
//
//        if textView.tag == 0 {
//            // Headers Text
//            print("textViewEndEditing_text_0: \(String(describing: textView.text))")
//
//        } else {
//            // Bodys Text
//            print("textViewEndEditing_text_1: \(String(describing: textView.text))")
//
//        }
//    }
    
    // MARK: Lazy Load
    private lazy var myTable: UITableView = {
        let tableFrame = CGRect.init(x: 18,
                                     y: 0,
                                     width: UIScreen.main.bounds.size.width - 18*2,
                                     height: UIScreen.main.bounds.size.height)

        let table = UITableView.init(frame: tableFrame,
                                     style: .grouped)
        table.delegate = self as! UITableViewDelegate
        table.dataSource = self

        table.backgroundColor = UIColor.LightTheme.backgroundColor
        table.tableFooterView = UIView()
        table.separatorStyle = .none//UITableViewCellSeparatorStyleNone

        return table
    }()
    
    private lazy var urlField: UITextField = {
        let urlField = UITextField()
        urlField.delegate = self as? UITextFieldDelegate

        return urlField
    }()
    
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

        let scanButton = UIButton.init(type: .system)
        scanButton.frame = CGRect(x: headerView.frame.width-35,
                                  y: 45/2-35/2,
                                  width: 35,
                                  height: 35)
        scanButton.setImage(UIImage.init(systemName: "viewfinder.circle"), for: .normal)
        scanButton.tintColor = .black
        headerView.addSubview(scanButton)


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
        urlField.leftViewMode = .always

        headerView.addSubview(urlField)


        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: -10, width: urlField.frame.width, height: 40)
        toolBar.tintColor = .black
//        toolBar.backgroundColor = .red
//        toolBar.barTintColor = .clear
        let doneItem = UIBarButtonItem.init(barButtonSystemItem: .done,
                                            target: self,
                                            action: #selector(hideKeyboard))
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace,
                                             target: nil,
                                             action: nil)
        toolBar.items = [spaceItem, doneItem]
        urlField.inputAccessoryView = toolBar

        let headerTitle = UILabel()
        headerTitle.frame = CGRect.init(x: 0,
                                        y: urlField.frame.maxY + 20,
                                       width: headerView.frame.width,
                                       height: 45)
        headerTitle.text = TableViriables.kHeaderTitles[0]
        headerTitle.textAlignment = .left
        headerTitle.text = "Headers"
        headerTitle.font = UIFont(name: "Helvetica-Bold", size: 22)!
        headerTitle.textColor = .black
        headerTitle.backgroundColor = .clear
        headerView.addSubview(headerTitle)


        return headerView
    }()
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    private lazy var headersView: UIView = {
        let headerV = UIView()
       
        
        return headerV
    }()
    
    private lazy var bodysView: UIView = {
        let bodyV = UIView.init(frame: CGRect.init(x: 0,
                                                   y: 0,
                                                   width: myTable.frame.width,
                                                   height: 50))
        bodyV.backgroundColor = .clear

        // Title Label
        let titleLabel = UILabel()
        titleLabel.frame = CGRect.init(x: 0,
                                      y: 0,
                                      width: bodyV.frame.width,
                                      height: 45)
        titleLabel.text = TableViriables.kHeaderTitles[0]
        titleLabel.textAlignment = .left
        titleLabel.text = "Bodys"
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 22)!
        titleLabel.textColor = .black
        titleLabel.backgroundColor = .clear
        bodyV.addSubview(titleLabel)
        
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

//class TextViewCell: UITableViewCell {
//    // MARK: UI Elements
//    /// Refrence of the parent table view so that it can be updated
//    var tableView: UITableView!
//
//    lazy var textView: UITextView = {
//        let textView = UITextView()
//        textView.isScrollEnabled = false
//        return textView
//    }()
//
//    // MARK: Padding Variables
//    let padding: CGFloat = 50
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        addSubviews()
//        addConstraints()
//    }
//
//    func addSubviews() {
//        contentView.addSubview(textView)
//    }
//
//    func addConstraints() {
//        textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
//        textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
//        textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
//        textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

//extension TextViewCell: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        self.tableView.beginUpdates()
//        self.tableView.endUpdates()
//    }
//}

//class MultiLineTextInputTableViewCell: UITableViewCell {
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet var textView: UITextView!
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
//    var textString: String {
//        get {
//            return textView.text
//        } set {
//            textView.text = newValue
//            textViewDidChange(textView)
//        }
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        textView.isScrollEnabled = false
//        textView.delegate = self as! UITextViewDelegate
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        if selected {
//            textView.becomeFirstResponder()
//        } else {
////            textView.resignFirstResponder()
//        }
//    }
//}
//
//extension MultiLineTextInputTableViewCell: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        let size = textView.bounds.size
//        let newSize = textView.sizeThatFits(CGSize(width: size.width,
//                                                   height: CGFloat.greatestFiniteMagnitude))
//        if size.height != newSize.height {
//            UIView.setAnimationsEnabled(false)
//            tableView?.beginUpdates()
//            tableView?.endUpdates()
//
//            UIView.setAnimationsEnabled(true)
//
//            if let thisIndexPath = tableView?.indexPath(for: self) {
//                tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
//            }
//        }
//    }
//}
//
//extension UITableViewCell {
//    var tableView: UITableView? {
//        get {
//            var table: UIView? = superview
//            while !(table is UITableView) && table != nil {
//                table = table?.superview
//            }
//
//            return table as? UITableView
//        }
//    }
//}
