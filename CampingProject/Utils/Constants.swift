//
//  Constants.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/23.
//

import Foundation
import UIKit

enum API {
    static let BaseUrl = "https://camtorage.bamdule.com/camtorage/api/"
    static let BaseUrlMyself = "https://camtorage.bamdule.com/camtorage/api/myself/"

}

enum DB {
    static let userDefaults = UserDefaults.standard
}

enum emailType:String {
    case REGISTER = "REGISTER"
    case FIND_PASSWORD = "FIND_PASSWORD"
}

enum AppstoreOpenError: Error {
    case invalidAppStoreURL
    case cantOpenAppStoreURL
}

struct CheckAppVersion {
    
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let appleID = "1615353997"
    static let url = "itms-apps://itunes.apple.com/app/apple-store/\(appleID)"
    
    static func latestVersion() -> String? {
    
         guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)"),
               let data = try? Data(contentsOf: url),
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
               let results = json["results"] as? [[String: Any]],
               let appStoreVersion = results[0]["version"] as? String else {
             return nil
         }
         return appStoreVersion
    }

    static func openAppStore(urlStr: String) -> Result<Void, AppstoreOpenError> {
        guard let url = URL(string: urlStr) else {
            return .failure(.invalidAppStoreURL)
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return .success(())
        } else {
            return .failure(.cantOpenAppStoreURL)
        }
    }
 }
