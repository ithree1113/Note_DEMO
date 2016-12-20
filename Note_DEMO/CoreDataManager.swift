//
//  ContextManager.swift
//  Note_DEMO
//
//  Created by 鄭宇翔 on 2016/11/21.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static var sharedInstance = CoreDataManager()
    
    private var theContext: NSManagedObjectContext
    
    private init() {
        self.theContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // Save the change of CoreData
    func save() {
        do {
            try self.theContext.save()
        } catch  {
            fatalError("\(error)")
        }
    }
    
    //Insert a new data into CoreData
    func insert(_ theEntityName: String, attributeInfo: [String: String]?) -> NSManagedObject {
        
        let insertData = NSEntityDescription.insertNewObject(forEntityName: theEntityName, into: self.theContext)
        
        if let attribute = attributeInfo {
            for(key, value) in attribute {
                let type = insertData.entity.attributesByName[key]?.attributeType
                
                // According the type to translate the data format of value.
                if (type == .integer16AttributeType ||
                    type == .integer32AttributeType ||
                    type == .integer64AttributeType) {
                    insertData.setValue(Int(value), forKey: key)
                } else if (type == .floatAttributeType ||
                    type == .doubleAttributeType) {
                    insertData.setValue(Double(value), forKey: key)
                } else if (type == .booleanAttributeType) {
                    insertData.setValue((value == "true" ? true : false), forKey: key)
                } else if (type == .stringAttributeType) {
                    insertData.setValue(value, forKey: key)
                }
            }
        }
        
        self.save()
        
        return insertData
    }
    
    // Load data from CoreData
    func load(_ theEntityName: String, byPredicate: String?, bySort: [String: Bool]?, byLimit: Int?) -> [NSManagedObject]? {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: theEntityName)
        
        if let predicate = byPredicate {
            request.predicate = NSPredicate(format: predicate)
        }
        
        if let sort = bySort {
            var sortArr: [NSSortDescriptor] = []
            for (key, value) in sort {
                sortArr.append(NSSortDescriptor(key: key, ascending: value))
            }
            request.sortDescriptors = sortArr
        }
        
        if let limitNum = byLimit {
            request.fetchLimit = limitNum
        }
        
        do {
            return try self.theContext.fetch(request) as? [NSManagedObject]
        } catch  {
            fatalError("\(error)")
        }
    }
    
    // Delete data in CoreData by Predicate
    func delete(_ theEntityName: String, byPredicate: String?) {
        if let results = self.load(theEntityName, byPredicate: byPredicate, bySort: nil, byLimit: nil) {
            
            for result in results {
                self.theContext.delete(result)
            }
            self.save()
        }
    }
    
    // Delete data in CoreData by NSManagedObject
    func delete(selectedData: NSManagedObject) {
        self.theContext.delete(selectedData)
        self.save()
    }
    
    // Update data in CoreData
    func update(_ theEntityName: String, byPredicate: String?, attributeInfo: [String: String]) {
        
        if let results = self.load(theEntityName, byPredicate: byPredicate, bySort: nil, byLimit: nil) {
            for result in results {
                for(key, value) in attributeInfo {
                    let type = result.entity.attributesByName[key]?.attributeType
                    
                    // According the type to translate the data format of value.
                    if (type == .integer16AttributeType ||
                        type == .integer32AttributeType ||
                        type == .integer64AttributeType) {
                        result.setValue(Int(value), forKey: key)
                    } else if (type == .floatAttributeType ||
                        type == .doubleAttributeType) {
                        result.setValue(Double(value), forKey: key)
                    } else if (type == .booleanAttributeType) {
                        result.setValue((value == "true" ? true : false), forKey: key)
                    } else if (type == .stringAttributeType) {
                        result.setValue(value, forKey: key)
                    }
                }
            }
            self.save()
        }
    }
    
    
}
