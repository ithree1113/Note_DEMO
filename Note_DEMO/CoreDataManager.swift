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
    
    /**
     This a method that saves data after a modification.
     
     */
    func save() {
        do {
            try self.theContext.save()
        } catch  {
            fatalError("\(error)")
        }
    }
    
    /**
     This a method that inserts data form a specific entity.
     
     - Parameter theEntityName: A specific entity name.
     - Parameter attributeInfo: A dictionary to insert, such as [attribute name: value].
     - Returns: The NSManagedObject just inserting.
     */
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
    
    /**
     This a method that loads data form a specific entity with some condictions.
     
     - Parameter theEntityName: A specific entity name.
     - Parameter withPredicate: The specfic condiction of some attributes.
     - Parameter withSort: A dictionary to sort, such as [attribute name: ascending].
     - Parameter withLimit: The limit of searching results.
     - Returns: A array of searching results.
     */
    func load(_ theEntityName: String, withPredicate: String?, withSort: [String: Bool]?, withLimit: Int?) -> [NSManagedObject]? {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: theEntityName)
        
        if let predicate = withPredicate {
            request.predicate = NSPredicate(format: predicate)
        }
        
        if let sort = withSort {
            var sortArr: [NSSortDescriptor] = []
            for (key, value) in sort {
                sortArr.append(NSSortDescriptor(key: key, ascending: value))
            }
            request.sortDescriptors = sortArr
        }
        
        if let limitNum = withLimit {
            request.fetchLimit = limitNum
        }
        
        do {
            return try self.theContext.fetch(request) as? [NSManagedObject]
        } catch  {
            fatalError("\(error)")
        }
    }
    
    /**
     This a method that deletes data form a specific entity with a predication.
     
     - Parameter theEntityName: A specific entity name.
     - Parameter withPredicate: The specfic condiction of some attributes.
     */
    func delete(_ theEntityName: String, withPredicate: String?) {
        if let results = self.load(theEntityName, withPredicate: withPredicate, withSort: nil, withLimit: nil) {
            
            for result in results {
                self.theContext.delete(result)
            }
            self.save()
        }
    }
    
    /**
     This a method that deletes data directly.
     
     - Parameter selectedData: The data that needed to be deleted.
     */
    func delete(selectedData: NSManagedObject) {
        self.theContext.delete(selectedData)
        self.save()
    }

    /**
     This a method that updates data form a specific entity with some condictions.
     
     - Parameter theEntityName: A specific entity name.
     - Parameter withPredicate: The specfic condiction of some attributes.
     - Parameter attributeInfo: A dictionary to update, such as [attribute name: new value].
     */
    func update(_ theEntityName: String, withPredicate: String?, attributeInfo: [String: String]) {
        
        if let results = self.load(theEntityName, withPredicate: withPredicate, withSort: nil, withLimit: nil) {
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
