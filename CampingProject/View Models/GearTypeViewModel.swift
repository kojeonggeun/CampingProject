//
//  GearModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/12.
//

import Foundation
import Alamofire


class GearTypeViewModel {
    private let manager = APIManager.shared
    
    var gearTypes: [GearType] {
        return manager.gearTypes
    }
    
    func GearTypeNumberOfSections() -> Int{
        return gearTypes.count
    }
    
}

