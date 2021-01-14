//
//  LayoutViewController.swift
//  SpamMsg
//
//  Created by 彭熙 on 2021/1/14.
//  Copyright © 2021 彭熙. All rights reserved.
//

import UIKit

class LayoutViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let blockNav = BlockListViewController()
        let spamNav = SpamViewController()

        blockNav.tabBarItem.title = "BlockList"
        spamNav.tabBarItem.title = "Spam"

        blockNav.tabBarItem.image = UIImage(named: "block-user")
        spamNav.tabBarItem.image = UIImage(named: "spam")
        self.viewControllers = [blockNav, spamNav]
        // 文字图片颜色
        self.view.tintColor = .blue
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
    }

}
