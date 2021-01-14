//
//  SpamViewController.swift
//  SpamMsg
//
//  Created by 彭熙 on 2021/1/13.
//  Copyright © 2021 彭熙. All rights reserved.
//

import UIKit
import CoreData

class SpamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var textInput: UITextField!
    var tableView: UITableView!
    var manageContext: NSManagedObjectContext!
    var phrases: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = "Spam"
        self.view.backgroundColor  = .white
        // Do any additional setup after loading the view.
        self.setUpUI()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - setup UI
        func setUpUI() {
            // 初始化
            phrases = [String]();
            manageContext = CoreDataStorage.shared.context
            CoreDataStorage.shared.removeAllSender(name:"SpamText")
            // 获取存储的senders
            manageContext.performAndWait{() -> Void in
            let spamFetch: NSFetchRequest<SpamText> = SpamText.fetchRequest()
            
            do {
                let results = try manageContext.fetch(spamFetch)
                            
                for spam in results {
                    phrases.append(spam.text!)
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
           let spamStr = textInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
           if(spamStr == "") {
               return
           }
           
           phrases.append(spamStr)
           
           // 存储
           let newSpam = SpamText(context: manageContext)
           newSpam.text = spamStr
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
           return phrases.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "DefalutCell", for: indexPath)
           cell.textLabel?.text = phrases[indexPath.row]
           
           return cell
       }
}
