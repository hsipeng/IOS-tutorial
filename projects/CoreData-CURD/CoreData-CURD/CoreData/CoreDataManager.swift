//
//  CoreDataManager.swift
//  CoreData-CURD
//
//  Created by 彭熙 on 2020/12/31.
//  Copyright © 2020 彭熙. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    // 单例
    static let shared = CoreDataManager()
    
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
    
    // 保存数据
    func savePersonWith(name: String, age: Int16) {
        let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person
        person.name = name
        person.age = age
        saveContext()
    }
    
    // 删除
    func deleteWith(name: String) {
        let fetchRequest: NSFetchRequest = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name=%@", name)
        do {
            let result = try context.fetch(fetchRequest)
            for person in result {
                context.delete(person)
            }
        } catch {
            fatalError("删除失败")
        }
    }
    
    
    // 获取所有数据
    func getAllPerson() -> [Person] {
        let fetchRequest: NSFetchRequest = Person.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            fatalError("查找失败")
        }
    }
}
