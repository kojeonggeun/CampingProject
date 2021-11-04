//
//  UserModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/05.
//

import Foundation

struct UserInfo: Decodable {
//    let code: String
    var user: User
    var followerCnt: Int
    var followingCnt: Int
    var gearCnt: Int
    var boardCnt: Int
    
}

struct User: Decodable {
    var id: Int
    var name: String?
    var email: String
    var phone: String?
    var userImageId: Int?
    var userImageUrl: String
    var isPublic: Bool
    
    init(){
        self.id = 0
        self.name = ""
        self.email = ""
        self.phone = ""
        self.userImageId = 0
        self.userImageUrl = "https://doodleipsum.com/700/avatar-2?i"
        self.isPublic = false
        
    }
}




