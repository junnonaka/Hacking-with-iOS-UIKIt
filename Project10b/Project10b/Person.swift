//
//  Person.swift
//  Project10b
//
//  Created by 野中淳 on 2022/12/09.
//

import UIKit

class Person: NSObject {
    var name:String
    var image:String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
