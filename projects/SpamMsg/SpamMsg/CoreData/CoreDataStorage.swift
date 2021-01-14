//
//  CoreDataStorage.swift
//  SpamMsg
//
//  Created by 彭熙 on 2021/1/14.
//  Copyright © 2021 彭熙. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStorage: NSObject {
    // 单例
    static let shared = CoreDataStorage()
    
    // NSManagedObjectContext
    lazy var context: NSManagedObjectContext = {
        return ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    }()
    
    // 更新数据
    private func saveContext() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved err \(nserror), \(nserror.userInfo)")
        }
    }
    
    // 清除所有Sender
    func removeAllSender(name: String) {
        if(name == ""){
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let deleRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleRequest)
            self.saveContext()
        } catch {
            fatalError("删除失败")
        }

    }
    
}
