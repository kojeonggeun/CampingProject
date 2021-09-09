//
//  UserGearViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/09.
//

import Foundation
import UIKit


class UserGearViewModel {
    
    private let manager = APIService.shared
    
    var userGears: [CellData] {
        return manager.userGears
    }
    
    func addUserGear(name: String, type: Int, color: String, company: String, capacity: String, date: String, price: String, image: [UIImage], imageName: [String]){
        
        manager.addGear(name: name, type: type, color: color, company: company, capacity: capacity, date: date, price: price, image: image, imageName: imageName)
    }
    
    func deleteUserGear(gearId: Int){
        manager.deleteGear(gearId: gearId)
    }
    
    func editUserGear(){
        
    }
}
