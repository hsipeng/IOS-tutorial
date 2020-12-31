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
        label = UILabel(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width - 100, height: self.contentView.frame.height))
        delBtn = UIButton(frame: CGRect(x: self.contentView.frame.width - 100, y: 0, width: 80, height: self.contentView.frame.height))
        delBtn.backgroundColor = .red
        delBtn.setTitleColor(.white, for: .normal)
 
        self.contentView.addSubview(label)
        self.contentView.addSubview(delBtn)
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
