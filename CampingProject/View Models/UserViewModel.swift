//
//  UserModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/07/29.
//

import Foundation
import Alamofire
import UIKit
import RxSwift

import AlamofireImage


class UserViewModel {

    static let shared = UserViewModel()
    let api = APIManager.shared
 
    func loadUserInfoRx() -> Observable<UserInfo>{
        return Observable.create() { emitter in
            self.api.loadUserInfo() { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func loadFriendInfoRx(id: Int) -> Observable<UserInfo>{
        return Observable.create() { emitter in
            self.api.loadFriendInfo(friendId: id) { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func loadUserGearRx() -> Observable<[CellData]>{
        return Observable.create() { emitter in
            self.api.loadUserGear() { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func loadDetailUserGearRx(userId: Int, gearId: Int) -> Observable<GearDetail>{
        return Observable.create() { emitter in
            self.api.loadDetailUserGear(userId: userId, gearId: gearId) { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    
    func loadFollowerRx() -> Observable<Friends>{
        return Observable.create() { emitter in
            self.api.loadFollower() { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
   
    func loadFollowingRx() -> Observable<Friends>{
        return Observable.create() { emitter in
            self.api.loadFollowing() { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func loadDeleteFollowergRx(id: Int) -> Observable<Bool>{
        
        return Observable.create() { emitter in
            self.api.deleteFollower(id: id) { result in
                    emitter.onNext(result)
                    emitter.onCompleted()
                }
            return Disposables.create()
        }
    }
    
    func loadGearImagesRx(id: Int) -> Observable<UIImage>{
        return Observable.create() { emitter in
            self.api.loadGearImages(gearId: id) { result in
                    emitter.onNext(result)
                    emitter.onCompleted()
                }
            return Disposables.create()
        }
    }
    
    func loadGearDetailImagesRx(id: Int) -> Observable<[UIImage]>{
        return Observable.create() { emitter in
            self.api.loadGearDetailImages(gearId: id) { result in
                    emitter.onNext(result)
                    emitter.onCompleted()
                }
            return Disposables.create()
        }
    }
    
    func loadSearchUserGearRx(userId: Int) -> Observable<[CellData]>{
        return Observable.create() { emitter in
            self.api.loadSearchUserGear(id:userId) { result in
                emitter.onNext(result)
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func emailDuplicateCheckRx(email:String) -> Observable<Bool>{
        return Observable.create() { emitter in
            self.api.checkEmailDuplicate(email:email) { result in
                emitter.onNext(result)
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func requestEmailCertificationCodeRx(email:String) -> Observable<Bool> {
        return Observable.create() { emitter in
            self.api.requestEmailCertificationCode(email:email) { result in
                emitter.onNext(result)
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }

    func returnToken() -> String{
        let tokenDict =  DB.userDefaults.value(forKey: "token") as! NSDictionary
        let token = tokenDict["token"] as! String
        
        return token
    }
}
