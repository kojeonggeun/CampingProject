//
//  SearchUserModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/14.
//

import Foundation


struct SearchResult: Decodable {
    var users: [SearchUser] = []
}

struct SearchUser: Decodable {
    var id: Int
    var name: String
    var email:String
    var phone: String
    
//    이미지 추가 전
    var userImageId: Int?
    var userImageUrl: String
    
    var isPublic: Bool
    
}
