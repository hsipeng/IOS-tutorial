//
//  FilterMLModelManager.swift
//  SpamMsg
//
//  Created by 彭熙 on 2021/1/14.
//  Copyright © 2021 彭熙. All rights reserved.
//

import UIKit

class FilterMLModelManager: NSObject {
    // 单例
    static let shared = FilterMLModelManager()
    
    private func judgeTypeWithMessage(msg: String) -> String {
        var re = ""
        do {
            let filter = Filter()
            let result: FilterOutput = try filter.prediction(text: msg)
            print("\(msg) : filter output: \(result.label)")
            re = result.label
        }catch{
            fatalError("predicte fail.")
        }
        
        
        return re
    }
    
    public func needFilter(msg: String) -> Bool {
        let re = judgeTypeWithMessage(msg: msg)
        return re == "过滤"
    }
}
