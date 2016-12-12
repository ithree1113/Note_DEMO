//
//  Note.swift
//  Note_DEMO
//
//  Created by 鄭宇翔 on 2016/11/18.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

import UIKit
import CoreData

class Note: NSManagedObject {
    @NSManaged var text: String?
    @NSManaged var imageName: String?
    @NSManaged var index: Int16
    
    // Get the image by imageName from Document directory
    func image() -> UIImage? {
        if let dataName = self.imageName {
            
            let imageURL = MyNoteDirectory().getMyURL(.myPhoto).appendingPathComponent("\(dataName)")
            
            do {
                let imageData = try Data.init(contentsOf: imageURL)
                return UIImage(data: imageData)
            } catch  {
                print(error)
            }
        }
        return nil
    }
}
