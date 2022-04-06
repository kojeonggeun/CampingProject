//
//  CheckAppVersion.swift
//  Camtorage
//
//  Created by 고정근 on 2022/03/31.
//

import Foundation
import UIKit
import RxSwift

class AppVersionManager: NSObject{

    static let shared = AppVersionManager()
    override private init() {}

    func checkVersion(min:String) -> Observable<Void> {
        return Observable.create { emitter in
            
            let minimumVersion = min
            let currentVersion = CheckAppVersion.appVersion!
            let latestVersion = CheckAppVersion.latestVersion()!

//            현재버전과 미니멈 버전이 같을때 or 현재버전이 미니멈 버전보다 낮을때 -> 강제
//            현재버전이 미니엄 보다 높을때 and 현재버전이 최신버전보다 낮을때 -> 선택
            if self.compareVaersion(versionA: currentVersion, versionB: minimumVersion) == ComparisonResult.orderedAscending ||
                self.compareVaersion(versionA: currentVersion, versionB: minimumVersion) == ComparisonResult.orderedSame {
            
                let alert = UIAlertController(title: "업데이트 필수", message: "필수 업데이트가 있습니다. 이제 \(latestVersion)버전으로 업데이트 하십시오.", preferredStyle: .alert)
                alert.addAction(.init(title: "업데이트", style: .default, handler: {_ in
                    CheckAppVersion.openAppStore(urlStr: CheckAppVersion.url)
                }))
                
                DispatchQueue.main.async {
                    if let vc = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                        let ds = vc.visibleViewController
                          ds!.present(alert, animated: true, completion: nil)
                      }
                }
                
            } else if self.compareVaersion(versionA: currentVersion, versionB: minimumVersion) == ComparisonResult.orderedDescending &&
                self.compareVaersion(versionA: currentVersion, versionB: latestVersion) == ComparisonResult.orderedAscending {
                    let alert = UIAlertController(title: "업데이트 가능", message: "캠토리지의 새로운 버전이 있습니다. 이제 \(latestVersion)버전으로 업데이트 하십시오.", preferredStyle: .alert)
                    alert.addAction(.init(title: "업데이트", style: .default, handler: {_ in
                        CheckAppVersion.openAppStore(urlStr: CheckAppVersion.url)
                    }))
                    alert.addAction(.init(title: "다음에", style: .default, handler: {_ in
                        emitter.onNext(())
                        emitter.onCompleted()
                    }))
                    DispatchQueue.main.async {
                        if let vc = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                            let ds = vc.visibleViewController
                              ds!.present(alert, animated: true, completion: nil)
                          }
                    }
            } else {
                emitter.onNext(())
                emitter.onCompleted()
            }
            
      
            return Disposables.create()
        }
    }
    
    private func compareVaersion(versionA:String, versionB:String) -> ComparisonResult {
        
        let majorA = versionA.split(separator: ".").map{Int($0)!}[0]
        let majorB = versionB.split(separator: ".").map{Int($0)!}[0]

        if majorA < majorB {
            return ComparisonResult.orderedAscending
        } else if majorB < majorA {
            return ComparisonResult.orderedDescending
        }
        
        let minorA = versionA.split(separator: ".").map{Int($0)!}[1]
        let minorB = versionB.split(separator: ".").map{Int($0)!}[1]
        
        if minorA < minorB {
            return ComparisonResult.orderedAscending
        } else if minorB < minorA {
            return ComparisonResult.orderedDescending
        }
        
        return ComparisonResult.orderedSame
    }
}

    
