//
//  MyNoteURL.swift
//  Note_DEMO
//
//  Created by 鄭宇翔 on 2016/12/5.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

import UIKit

public enum MyDirectory : Int {
    case myPhoto
    //case myBackup  // if using Archiving

}

class MyNoteDirectory: MyDefaultDirectory {
    
    func getMyPath(_ myDirectory: MyDirectory) -> String {
        
        var resultPath: String
        
        switch myDirectory {
        case .myPhoto:
            resultPath = self.myDocumentsPath.appending("/Photo")
            break
        }
        
        if !(FileManager.default.fileExists(atPath: resultPath)) {
            do {
                let resultURL = URL(fileURLWithPath: resultPath)
                try FileManager.default.createDirectory(at: resultURL, withIntermediateDirectories: false, attributes: nil)
            } catch  {
                print(error)
            }
        }
        return resultPath
    }
    
    func getMyURL(_ myDirectory: MyDirectory) -> URL {
        return URL(fileURLWithPath: self.getMyPath(myDirectory))
    }
    
}
