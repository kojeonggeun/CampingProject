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
    
  
    func loadFollowerRx() -> Observable<[Friend]>{
        return Observable.create() { emitter in
            self.api.loadFollower() { result in
                    emitter.onNext(result)
                    emitter.onCompleted()
                }
            return Disposables.create()
        }
    }
   
    func loadFollowingRx() -> Observable<[Friend]>{
        return Observable.create() { emitter in
            self.api.loadFollowing() { result in
                    emitter.onNext(result)
                    emitter.onCompleted()
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
    
    
    func isValidEmail(email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z.%=-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        // 8~20자리 영어+숫자+특수문자 사용
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,20}"

        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with: password)
    }

    func returnToken() -> String{
        let tokenDict =  DB.userDefaults.value(forKey: "token") as! NSDictionary
        let token = tokenDict["token"] as! String
        
        
        return token
    }

}
