//
//  pictureStruct.swift
//  StormViewer_Project1
//
//  Created by Vaishant Makan on 07/12/20.
//

import Foundation

class pictureStruct: NSObject, Codable {
    
    var name: String
    var tapped: Int
    
    init(name: String, tapped: Int) {
        self.name = name
        self.tapped = tapped
    }
}
