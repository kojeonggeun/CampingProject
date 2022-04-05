//
//  CheckAppVersion.swift
//  Camtorage
//
//  Created by 고정근 on 2022/03/31.
//

import Foundation
import UIKit

class AppVersionManager: NSObject{

    static let sharedManager = AppVersionManager()
    override private init() {}

    func checkVersion(){
        
        let oldVersion = CheckAppVersion.appVersion
        let latestVersion = CheckAppVersion.latestVersion()
        let compareResult = oldVersion!.compare(latestVersion!, options: .numeric)
        
        switch compareResult {
        case .orderedAscending:
            let alert = UIAlertController(title: "업데이트 가능", message: "캠토리지의 새로운 버전이 있습니다. 이제 \(latestVersion!)버전으로 업데이트 하십시오.", preferredStyle: .alert)
            alert.addAction(.init(title: "업데이트", style: .default, handler: {_ in
                CheckAppVersion.openAppStore(urlStr: CheckAppVersion.url)
            }))
            alert.addAction(.init(title: "다음에", style: .default, handler: {_ in
                
            }))
            DispatchQueue.main.async {

                if let vc = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                    let ds = vc.visibleViewController
                      ds!.present(alert, animated: true, completion: nil)
                  }
            }
        case .orderedDescending:
            break
           
        case .orderedSame:
            break
        
        }
        
    }
}

    
