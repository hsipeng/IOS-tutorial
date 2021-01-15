//
//  BlockListViewController.swift
//  SpamMsg
//
//  Created by 彭熙 on 2021/1/13.
//  Copyright © 2021 彭熙. All rights reserved.
//

import UIKit
import CoreData

class BlockListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var textInput: UITextField!
    var tableView: UITableView!
    var manageContext: NSManagedObjectContext!
    var senders: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tabBarController?.title = "BlockList"
        self.view.backgroundColor = .white
        self.setUpUI()
    }
    
    // MARK: - setup UI
    func setUpUI() {
        
        let messageBody = "红都百货x楼婷美专柜x.x节活动火热进行中。一年仅一次的最大活动力度！充值送："
        let filterManage = FilterMLModelManager.shared
        if(filterManage.needFilter(msg: messageBody)) {
            NSLog("垃圾短信,过滤")
        }else {
            NSLog("不是垃圾短信，正常")
        }
        filterManage.judgeMessageWithSklearn(msg: inputMsg)
        // 初始化
        senders = [String]();
        
        manageContext = CoreDataStorage.shared.context
//        CoreDataStorage.shared.removeAllSender(name:"Sender")
        // 获取存储的senders
        manageContext.performAndWait{() -> Void in
            let senderFetch: NSFetchRequest<Sender> = Sender.fetchRequest()
            
            do {
                let results = try manageContext.fetch(senderFetch)
                
                for sender in results {
                    senders.append(sender.name!)
                }
            }
            catch let error as NSError{
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
        }
        
        let label = UILabel()
        label.text = "please add spam phrases to the black list"
        label.textColor = .blue
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        let img1 = UIImageView(image: UIImage(named: "block-user"))
        
        let addBtn: UIButton = {
           let b = UIButton()
            b.translatesAutoresizingMaskIntoConstraints = false
            b.backgroundColor = .white
            b.setImage(UIImage(named: "plus"), for: .normal)
            return b
        }()
        
        textInput = UITextField()
        textInput.backgroundColor = .white
        textInput.borderStyle = .line
        textInput.layer.borderColor = UIColor.init(hexString: "#333333").cgColor
        textInput.font = UIFont.preferredFont(forTextStyle: .headline)
        textInput.setContentHuggingPriority(UILayoutPriority.defaultLow - 1.0, for: .horizontal)
        textInput.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh - 1.0, for: .horizontal)
        
        
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefalutCell")
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1.0
        tableView.delegate = self
        tableView.dataSource = self
        
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.axis = .horizontal
        
        stackView.addArrangedSubview(img1)
        stackView.addArrangedSubview(textInput)
        stackView.addArrangedSubview(addBtn)
        
        // 先添加，后布局!!!!!
        self.view.addSubview(label)
        self.view.addSubview(stackView)
        self.view.addSubview(tableView)
        // 布局
        // autoLayout 布局
        let safeArea = self.view.safeAreaLayoutGuide
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10).isActive = true
        safeArea.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10).isActive = true
        label.widthAnchor.constraint(equalTo: safeArea.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10).isActive = true
        safeArea.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 10).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0).isActive = true
        safeArea.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0).isActive = true
        safeArea.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0).isActive = true
        
        
        addBtn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func addBtnClick (sender: UIButton){
        NSLog("add btn clicked:  \(textInput.text!)")
        let senderName = textInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(senderName == "") {
            return
        }
        
        senders.append(senderName)
        // 存储
        let newSender = Sender(context: manageContext)
        newSender.name = senderName
        manageContext.performAndWait{() -> Void in
            do {
                try manageContext.save()
            }
            catch let error as NSError{
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
            textInput.text = ""
            tableView.reloadData()
            textInput.resignFirstResponder()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return senders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefalutCell", for: indexPath)
        cell.textLabel?.text = senders[indexPath.row]
        
        return cell
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
