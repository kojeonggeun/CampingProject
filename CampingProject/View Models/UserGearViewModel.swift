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
