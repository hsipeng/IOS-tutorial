//
//  FilterMLModelManager.swift
//  SpamMsg
//
//  Created by 彭熙 on 2021/1/14.
//  Copyright © 2021 彭熙. All rights reserved.
//

import UIKit
import CoreML

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
    
    // MARK:- tfidf
    private func tfidf(sms: String) -> MLMultiArray{
        let wordsFile = Bundle.main.path(forResource: "feature", ofType: "txt")
        let smsFile = Bundle.main.path(forResource: "SMSSpamCollection", ofType: "txt")
        do {
            let wordsFileText = try String(contentsOfFile: wordsFile!, encoding: String.Encoding.utf8)
            var wordsData = wordsFileText.components(separatedBy: .newlines)
            wordsData.removeLast() // Trailing newline.
            let smsFileText = try String(contentsOfFile: smsFile!, encoding: String.Encoding.utf8)
            var smsData = smsFileText.components(separatedBy: .newlines)
            smsData.removeLast() // Trailing newline.
            let wordsInMessage = sms.tokenize() //sms.split(separator: " ")
            print("wordsInMessage: \(wordsInMessage)")
            var vectorized = try MLMultiArray(shape: [NSNumber(integerLiteral: wordsData.count)], dataType: MLMultiArrayDataType.double)
            for i in 0..<wordsData.count{
                let word = wordsData[i]
                if sms.contains(word){
                    var wordCount = 0
                    for substr in wordsInMessage{
                        if substr.elementsEqual(word){
                            wordCount += 1
                        }
                    }
                    let tf = Double(wordCount) / Double(wordsInMessage.count)
                    var docCount = 0
                    for sms in smsData{
                        if sms.contains(word) {
                            docCount += 1
                        }
                    }
                    let idf = log(Double(smsData.count) / Double(docCount))
                    vectorized[i] = NSNumber(value: tf * idf)
                } else {
                    vectorized[i] = 0.0
                }
            }
            return vectorized
        } catch {
            return MLMultiArray()
        }
    }
    
    public func needFilter(msg: String) -> Bool {
        let re = judgeTypeWithMessage(msg: msg)
        return re == "过滤"
    }
    
    //MARK: - SklearnLogistic
    public func logisticClassifier(msg: String) -> Int64 {
        var re: Int64 = 0
        let vec = tfidf(sms: msg)
        do{
            let sklearnLc = SklearnLogistic()
            let prediction = try sklearnLc.prediction(message: vec).label
            re = prediction
            print("prediction: \(prediction)")
        }catch{
            fatalError("predict fail.")
        }
        return re
    }
    
}


// MARK:- String 拓展
extension String {

    func tokenize() -> [String] {
        let inputRange = CFRangeMake(0, self.utf16.count)
        let flag = UInt(kCFStringTokenizerUnitWord)
        let locale = CFLocaleCopyCurrent()
        let tokenizer = CFStringTokenizerCreate( kCFAllocatorDefault, self as CFString, inputRange, flag, locale)
        var tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        var tokens : [String] = []

        while tokenType != []
        {
            let currentTokenRange = CFStringTokenizerGetCurrentTokenRange(tokenizer)
            let substring = self.substringWithRange(aRange: currentTokenRange)
            tokens.append(substring)
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        }

        return tokens
    }

    func substringWithRange(aRange : CFRange) -> String {

        let nsrange = NSMakeRange(aRange.location, aRange.length)
        let substring = (self as NSString).substring(with: nsrange)
        return substring
    }
}
