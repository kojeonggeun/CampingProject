//
//  SearchUserModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/14.
//

import Foundation

public struct SearchResult: Decodable {
    var users: [SearchUser] = []
    var total: Int = 0
}

public struct SearchUser: Decodable {
    var id: Int
    var name: String
    var email: String
    var phone: String

    var userImageId: Int?
    var userImageUrl: String

    var isPublic: Bool

    init(name: String) {
        self.id = 0
        self.name = name
        self.email = ""
        self.phone = ""
        self.userImageId = 0
        self.userImageUrl = ""
        self.isPublic = true
    }
}
