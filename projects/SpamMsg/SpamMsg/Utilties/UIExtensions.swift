//
//  UIExtensions.swift
//  SpamMsg
//
//  Created by 彭熙 on 2021/1/14.
//  Copyright © 2021 彭熙. All rights reserved.
//

import UIKit

extension UIViewController {

    //MARK: Dismiss Keyboard on Tap
    func dismissKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
//        view.endEditing(true)
        view.resignFirstResponder()
    }

}
