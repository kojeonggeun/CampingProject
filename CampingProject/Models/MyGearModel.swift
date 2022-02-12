//
//  MyGearModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/26.
//

import Foundation
import UIKit
public struct CellData: Decodable {
    var id: Int
    var name: String?
    var gearTypeId: Int?
    var gearTypeName: String?
    var color: String?
    var company: String?
    var capacity: String?
    var price: Int?
    var buyDt: String?
    var description: String?
    var imageUrl: String?
}



public struct GearDetail: Decodable {
    var id: Int
    var name: String?
    var gearTypeId: Int?
    var gearTypeName: String?
    var color: String?
    var company: String?
    var capacity: String?
    var price: Int?
    var buyDt: String?
    var description: String?
    var images: [ImageData]
    
    
    
}
struct ImageData: Decodable {
    var imageId: Int
    var orgFilename: String
    var url: String
}
