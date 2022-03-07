//
//  UserModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/05.
//

import Foundation

public struct UserInfo: Codable {
    var user: User?
    var followerCnt: Int
    var followingCnt: Int
    var gearCnt: Int
    var boardCnt: Int
    var status: String?

    enum CodingKeys: CodingKey {
        case user, followerCnt, followingCnt, gearCnt, boardCnt, status
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = (try? values.decode(User.self, forKey: .user)) ?? nil
        followerCnt = (try? values.decode(Int.self, forKey: .followerCnt)) ?? 0
        followingCnt = (try? values.decode(Int.self, forKey: .followingCnt)) ?? 0
        gearCnt = (try? values.decode(Int.self, forKey: .gearCnt)) ?? 0
        boardCnt = (try? values.decode(Int.self, forKey: .boardCnt)) ?? 0
        status = (try? values.decode(String.self, forKey: .status)) ?? nil
    }
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

struct Login: Decodable{
    var token: String = ""
    var email: String = ""
}
