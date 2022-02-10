//
//  UserGearViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/09.
//

import Foundation
import UIKit


class UserGearViewModel {
    
    private let apiManager = APIManager.shared
    static let shared = UserGearViewModel()
    
    var categoryData: [CellData] = []
    
    var userGears: [CellData] {
        return apiManager.userGears
    }
    
//    func addUserGear(name: String, type: Int, color: String, company: String, capacity: String, date: String, price: String, image: [UIImage], imageName: [String]){
//        
//        apiManager.addGear(name: name, type: type, color: color, company: company, capacity: capacity, date: date, price: price, image: image, imageName: imageName)
//    }
    
    func deleteUserGear(gearId: Int){
        
        apiManager.deleteGear(gearId: gearId)
    }
    
    
    func editUserGear(gearId: Int,name: String, type: Int, color: String, company: String, capacity: String, date: String, price: String, image: [UIImage], imageName: [String], item: [ImageData]){
        
        apiManager.editGear(gearId: gearId,name: name, type: type, color: color, company: company, capacity: capacity, date: date, price: price, image: image, imageName: imageName, item: item)
    }
    
    func categoryUserData(type: String){
        categoryData.removeAll()
        for i in userGears{
            if i.gearTypeName == type {
                categoryData.append(i)
            }
        }
    }
    
    func deleteCategoryData(row: Int){
        categoryData.remove(at: row)
    }
    
    func numberOfRowsInSection() -> Int{
   
        return categoryData.count
    }
}
