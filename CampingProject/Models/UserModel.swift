//
//  UserModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/05.
//

import Foundation

struct UserInfo: Codable {
//    let code: String
    var user: User
    var followerCnt: Int = 0
    var followingCnt: Int = 0
    var gearCnt: Int = 0
    var boardCnt: Int = 0
    var status: String?
    
   
}

struct User: Codable {
    var id: Int = 0
    var name: String? = ""
    var email: String = ""
    var phone: String? = ""
    var userImageId: Int? = 0
    var userImageUrl: String = "https://doodleipsum.com/700/avatar-2?i"
    var isPublic: Bool = false
    var aboutMe: String = ""

}

