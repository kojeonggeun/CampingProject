//
//  GearModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/13.
//


struct GearType: Codable {
    var gearID: Int
    var gearName: String
    
    enum CodingKeys : String, CodingKey{
        case gearID = "id"
        case gearName =  "name"
    }
}

struct Response: Codable {
    var gearTypes: [GearType] = []
}

