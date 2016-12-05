//
//  MyNoteURL.swift
//  Note_DEMO
//
//  Created by 鄭宇翔 on 2016/12/5.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

import UIKit

public enum MyDirectoryURL : Int {
    case myPhotoURL
    //case myBackupURL  // if using Archiving

}

class MyNoteURL: MyDefaultURL {
    
    override init() {
        super.init()
        
    }
    
    func getMyURL(_ myURL: MyDirectoryURL) -> URL? {
        
        var resultURL: URL
        
        switch myURL {
        case .myPhotoURL:
            resultURL = self.myDocumentsURL.appendingPathComponent("Photo", isDirectory: true)
            break
        }
        
        if !(FileManager.default.fileExists(atPath: "\(self.myDocumentsPath)/Photo")) {
            do {
                try FileManager.default.createDirectory(at: resultURL, withIntermediateDirectories: false, attributes: nil)
            } catch  {
                print(error)
            }
        }
        return resultURL
    }
    
}
