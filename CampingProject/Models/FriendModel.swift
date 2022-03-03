//
//  FriendModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/04.
//

import Foundation

public struct Friends: Decodable {
    var contents: [Friend]
    var total: Int
}

public struct Friend: Decodable {
    var id: Int
    var friendId: Int
    var name: String
    var profileUrl: String
    var email: String
    var status: String

    init(name: String) {
        self.id = 0
        self.friendId = 0
        self.name = name
        self.profileUrl = ""
        self.email = ""
        self.status = ""
    }

}
