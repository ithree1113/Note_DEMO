//
//  MyDefaultURL.swift
//  Note_DEMO
//
//  Created by 鄭宇翔 on 2016/11/30.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

import Foundation


class MyDefaultURL {

    let myHomePath: String
    let myHomeURL: URL
    
    let myDocumentsPath: String
    let myDocumentsURL: URL
    
    init() {

        self.myHomePath = NSHomeDirectory()
        self.myHomeURL = URL(fileURLWithPath: "\(NSHomeDirectory())")
        
        self.myDocumentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        self.myDocumentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    
}
