//
//  ViewController.swift
//  CoreData-CURD
//
//  Created by 彭熙 on 2020/12/30.
//  Copyright © 2020 彭熙. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // 数据
    let dataCellID = "dataCellID"
    var dataArray: [Person] = [Person]()
    // name
    var nameLabel: UILabel!
    var nameInput: UITextField!
    // age
    var ageLabel: UILabel!
    var ageInput: UITextField!
    
    // btns
    var addBtn: UIButton!
    var refreshBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        self.setUpUI()
    }
    

    lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: CGRect(x: 0, y: 400, width: self.view.frame.width, height: 100), style: UITableView.Style.plain)
        let tableView = UITableView(frame: CGRect(x:0, y: 400, width: self.view.frame.width, height: 400))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: dataCellID)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setUpUI() {
        nameLabel = UILabel()
        nameLabel.text = "姓名:"
        nameLabel.textColor = .blue
        nameLabel.textAlignment = .right
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        nameInput = UITextField()
        nameInput.backgroundColor = .white
        nameInput.borderStyle = .line
        nameInput.layer.borderColor = UIColor.init(hexString: "#333333").cgColor
        nameInput.font = UIFont.preferredFont(forTextStyle: .headline)
        nameInput.setContentHuggingPriority(UILayoutPriority.defaultLow - 1.0, for: .horizontal)
        nameInput.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh - 1.0, for: .horizontal)
        
        
        ageLabel = UILabel()
        ageLabel.text = "年龄:"
        ageLabel.textColor = .blue
        nameLabel.textAlignment = .right
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        
        ageInput = UITextField()
        ageInput.backgroundColor = .white
        ageInput.borderStyle = .line
        ageInput.layer.borderColor = UIColor.init(hexString: "#333333").cgColor
        ageInput.layer.borderWidth = 1.0
        ageInput.font = UIFont.preferredFont(forTextStyle: .headline)
        ageInput.setContentHuggingPriority(UILayoutPriority.defaultLow - 1.0, for: .horizontal)
        ageInput.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh - 1.0, for: .horizontal)
        
        
        
        addBtn = UIButton()
        
        addBtn.setTitle("添加", for: .normal)
        addBtn.setTitleColor(.blue, for: .normal)
        addBtn.addTarget(self, action: #selector(onAddBtnPressd), for: .touchUpInside)
        
        
        refreshBtn = UIButton()
        
        refreshBtn.setTitle("刷新", for: .normal)
        refreshBtn.setTitleColor(.red, for: .normal)
        refreshBtn.addTarget(self, action: #selector(onrefreshBtnPressd), for: .touchUpInside)
        
        
        
        let stackView = UIStackView()
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(nameInput)
        stackView.frame = CGRect(x: 0, y: 44, width: self.view.frame.width, height: 100)
        
        
        // 布局
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        
        let stackView2 = UIStackView()
        stackView2.addArrangedSubview(ageLabel)
        stackView2.addArrangedSubview(ageInput)
        stackView2.frame = CGRect(x: 0, y: 144, width: self.view.frame.width, height: 100)

        stackView2.axis = .horizontal
        stackView2.alignment = .center
        stackView2.spacing = 8
        stackView2.distribution = .fill
        stackView2.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView2.isLayoutMarginsRelativeArrangement = true
        
        
        
        // btns stackview
        
        let stackView3 = UIStackView()
        stackView3.axis = .horizontal
        stackView3.alignment = .center
        stackView3.spacing = 8
        stackView3.distribution = .fillEqually
        
        stackView3.addArrangedSubview(addBtn)
        stackView3.addArrangedSubview(refreshBtn)
        
        stackView3.frame = CGRect(x: 0, y: 250, width: self.view.frame.width, height: 50)
        
//        let scrollView = UIScrollView()
//        scrollView.frame = CGRect(x: 0, y: 44, width: self.view.frame.width, height: self.view.frame.height - 44)
//        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - 44)
//        scrollView.addSubview(stackView)
//        scrollView.addSubview(stackView2)
//        scrollView.addSubview(stackView3)
//        scrollView.addSubview(tableView)
//        self.view.addSubview(scrollView)
        self.view.addSubview(stackView)
        self.view.addSubview(stackView2)
        self.view.addSubview(stackView3)
        self.view.addSubview(tableView)
        
    }
    
    // 添加 btn
    @objc func onAddBtnPressd(sender: UIButton!){
        resignKeyboard()
        guard let nameString = nameInput.text else { return }
        guard let ageString = ageInput.text else { return }
        guard let age = Int16(ageString) else { return }
        CoreDataManager.shared.savePersonWith(name: nameString, age: age)
        print("add btn pressed ", nameString, age)
    }
    
    // 刷新 btn
    @objc func onrefreshBtnPressd(sender: UIButton!){
        resignKeyboard()
        dataArray = CoreDataManager.shared.getAllPerson()
        tableView.reloadData()
        
        print("referesh btn pressed -------- :\n", dataArray)
    }
    
    private func resignKeyboard(){
        nameInput.resignFirstResponder()
        ageInput.resignFirstResponder()
    }
    
    // 删除 btn
    @objc func onTableCellRemove(_ sender: UIButton!){
        resignKeyboard()
        let row = sender.tag
//        dataArray.remove(at: row)
        let person = dataArray[row]
        CoreDataManager.shared.deleteWith(name: person.name ?? "")
        tableView.reloadData()
        print("table cell del btn pressed ,index: ", row, person)
    }
}

// MARK: - hex color
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


// MARK: - UITableViewDelegate，UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PersonTableViewCell()
        cell.label?.numberOfLines = 0
        cell.selectionStyle = .none
        let person = dataArray[indexPath.row]
        let personInfo = person.name! + "\n Age: \(String(describing: person.age))"
        print("person ----- : \n", personInfo)
        cell.label?.text = personInfo
        cell.delBtn?.setTitle("删除", for: .normal)
        // 传递参数
        cell.delBtn?.tag = indexPath.row
        cell.delBtn?.addTarget(self, action: #selector(onTableCellRemove), for: .touchUpInside)
        return cell
    }
    

}

