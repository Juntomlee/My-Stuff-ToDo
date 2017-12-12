//
//  ToDo.swift
//  ToDoList
//
//  Created by jun lee on 9/26/17.
//  Copyright © 2017 jun lee. All rights reserved.
//

import Foundation
import UIKit

class ToDo: NSObject, NSCoding{
    var title: String
    var detail: [String]
    var isCompleted: [Bool]
    
    init?(title: String, detail: [String], isCompleted: [Bool]){
        self.title = title
        self.detail = detail
        self.isCompleted = isCompleted
    }
    
    required init(coder decoder: NSCoder) {
        self.title = decoder.decodeObject(forKey: "title") as? String ?? ""
        self.detail = decoder.decodeObject(forKey: "detail") as? [String] ?? []
        self.isCompleted = decoder.decodeObject(forKey: "isCompleted") as? [Bool] ?? []
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(detail, forKey: "detail")
        coder.encode(isCompleted, forKey: "isCompleted")
    }
}
