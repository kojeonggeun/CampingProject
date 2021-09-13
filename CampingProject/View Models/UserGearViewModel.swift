//
//  UserGearViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/09.
//

import Foundation
import UIKit


class UserGearViewModel {
    
    private let manager = APIManager.shared
    
    var userGears: [CellData] {
        return manager.userGears
    }
    
    func addUserGear(name: String, type: Int, color: String, company: String, capacity: String, date: String, price: String, image: [UIImage], imageName: [String]){
        
        manager.addGear(name: name, type: type, color: color, company: company, capacity: capacity, date: date, price: price, image: image, imageName: imageName)
    }
    
    func deleteUserGear(gearId: Int, section: Int, row: Int){
        print(gearId)
        manager.deleteGear(gearId: gearId, section: section, row: row)
    }
    
    func editUserGear(){
        
    }
}
