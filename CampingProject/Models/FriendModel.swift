//
//  FriendModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/04.
//

import Foundation

struct Friends: Decodable {
    var description: String
    var friends: [Friend]
}

struct Friend: Decodable {
    var id: Int
    var friendId: Int
    var name: String
    var profileUrl: String
    var email: String
    var status: String
}
