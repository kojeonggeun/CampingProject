//
//  UserModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/07/29.
//

import Foundation

struct User {
    var email: String
    var password: String
    
    init(email: String, password: String){
        self.email = email
        self.password = password
    }
    
    
}
