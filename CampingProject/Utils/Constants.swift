//
//  Constants.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/23.
//

import Foundation
import UIKit

enum API {
    static let BASE_URL = "https://camtorage.bamdule.com/camtorage/api/"
    static let BASE_URL_MYSELF = "https://camtorage.bamdule.com/camtorage/api/myself/"
    static let token = DB.userDefaults.value(forKey: "token") as! NSDictionary
    static let tokenString = token["token"] as! String
}

enum DB{
    static let userDefaults = UserDefaults.standard
}


