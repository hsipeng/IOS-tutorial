//
//  PersonTableViewCell.swift
//  CoreData-CURD
//
//  Created by 彭熙 on 2020/12/31.
//  Copyright © 2020 彭熙. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    var label: UILabel!
    var delBtn: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        label = UILabel(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width - 100, height: self.contentView.frame.height))
        label = UILabel()
//        delBtn = UIButton(frame: CGRect(x: self.contentView.frame.width - 100, y: 0, width: 80, height: self.contentView.frame.height))
        delBtn = UIButton()
        delBtn.backgroundColor = .red
        delBtn.setTitleColor(.white, for: .normal)
        delBtn.contentHorizontalAlignment = .center
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(delBtn)
        
        // autoLayout
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
        
        
        delBtn.translatesAutoresizingMaskIntoConstraints = false
        delBtn.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
        delBtn.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10).isActive = true
        delBtn.widthAnchor.constraint(equalTo: label.widthAnchor, multiplier: 0.3).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
