//
//  GearModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/13.
//

public struct Response: Decodable {
    var gearTypes: [GearType] = []
    let appVersion: AppVersion
}

public struct GearType: Decodable {
    var gearID: Int
    var gearName: String

    enum CodingKeys: String, CodingKey {
        case gearID = "id"
        case gearName =  "name"
    }
}

public struct AppVersion: Decodable {
    let device: String
    let minimumVersion: String

}
