//
//  UserModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/05.
//

import Foundation

struct UserInfo: Codable {
    let code: String
    var user: User
    let followerCnt: Int
    let followingCnt: Int
    let gearCnt: Int
    let boardCnt: Int
    
}

struct User: Codable {
    let id: Int
    let name: String?
    let email: String
    let phone: String?
    let userImageId: Int
    let userImageUrl: String
    let userImagePath: String
    let isPublic: Bool
    
    init(){
        self.id = 0
        self.name = ""
        self.email = ""
        self.phone = ""
        self.userImageId = 0
        self.userImageUrl = ""
        self.userImagePath = ""
        self.isPublic = false
        
    }
}


