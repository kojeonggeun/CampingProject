//
//  ViewGear.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/23.
//

import Foundation

struct ViewGear {
    var id: Int
    var name: String
    var type: String
    var date: String
    var imageUrl: String

    
    init(_ item: CellData) {
        id = item.id
        name = item.name ?? ""
        type = item.gearTypeName ?? ""
        date = item.buyDt ?? ""
        imageUrl = item.imageUrl!

    }
    init(id: Int ,name: String, type: String, date: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.type = type
        self.date = date
        self.imageUrl = imageUrl
    }
    
    
}
