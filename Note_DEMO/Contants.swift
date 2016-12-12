//
//  Contants.swift
//  Note_DEMO
//
//  Created by 鄭宇翔 on 2016/12/12.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

import Foundation

struct Contants {
    
    struct Segues {
       static let listToNote = "listToNote"
    }
    
    struct NSDefaultKeys {
        static let noteIndex = "noteIndex"
    }
    
    struct CellIdentifiers {
        static let noteCell = "noteCell"
    }
    
    struct CoredataEntity {
        struct Note {
            static let Note = "Note" // This entity name
            static let imageName = "imageName"
            static let text = "text"
            static let index = "index"
        }
    }
    
}
