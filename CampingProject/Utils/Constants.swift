//
//  Constants.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/23.
//

import Foundation
import UIKit

enum API {
    static let BaseUrl = "http://camtorage.bamdule.com/camtorage/api/"
    static let BaseUrlMyself = "http://camtorage.bamdule.com/camtorage/api/myself/"

}

enum DB {
    static let userDefaults = UserDefaults.standard
}

enum emailType:String {
    case REGISTER = "REGISTER"
    case FIND_PASSWORD = "FIND_PASSWORD"
}
