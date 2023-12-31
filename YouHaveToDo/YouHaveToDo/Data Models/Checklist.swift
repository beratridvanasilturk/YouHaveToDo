//
//  Checklist.swift
//  YouHaveToDo
//
//  Created by Berat Rıdvan Asiltürk on 26.07.2023.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ToDoListItem]()
    
    // Bu init metodu ile Checklist nesnelerinin artık her zaman name özelliğinin olmasi gerektigini garanti eder.
    init(name: String) {
        self.name = name
        super.init()
    }
}
