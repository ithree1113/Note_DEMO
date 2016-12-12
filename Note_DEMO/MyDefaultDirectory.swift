//
//  MyDefaultURL.swift
//  Note_DEMO
//
//  Created by 鄭宇翔 on 2016/11/30.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

import Foundation


class MyDefaultDirectory {

    var myHomePath: String {
        return NSHomeDirectory()
    }
    var myHomeURL: URL {
        return URL(fileURLWithPath: "\(NSHomeDirectory())")
    }
    
    var myDocumentsPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    var myDocumentsURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    
}
