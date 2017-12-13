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
    var listTitle: String
    var listItems: [String]
    var isCompleted: [Bool]
    
    init?(listTitle: String, listItems: [String], isCompleted: [Bool]){
        self.listTitle = listTitle
        self.listItems = listItems
        self.isCompleted = isCompleted
    }
    
    required init(coder decoder: NSCoder) {
        self.listTitle = decoder.decodeObject(forKey: "listTitle") as? String ?? ""
        self.listItems = decoder.decodeObject(forKey: "listItems") as? [String] ?? []
        self.isCompleted = decoder.decodeObject(forKey: "isCompleted") as? [Bool] ?? []
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(listTitle, forKey: "listTitle")
        coder.encode(listItems, forKey: "listItems")
        coder.encode(isCompleted, forKey: "isCompleted")
    }
}
