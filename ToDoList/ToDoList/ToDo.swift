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
    var check: [String]
    
    init?(title: String, detail: [String], check: [String]){
        self.title = title
        self.detail = detail
        self.check = check
    }
    
    required init(coder decoder: NSCoder) {
        self.title = decoder.decodeObject(forKey: "title") as? String ?? ""
        self.detail = decoder.decodeObject(forKey: "detail") as? [String] ?? []
        self.check = decoder.decodeObject(forKey: "check") as? [String] ?? []
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(detail, forKey: "detail")
        coder.encode(check, forKey: "check")
    }
}
