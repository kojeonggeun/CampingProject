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
    
    let url = API.BASE_URL
    let urlUser = API.BASE_URL_MYSELF
    
    var friendInfo: [UserInfo] = []
    var followers: [Friend] = []
    var followings: [Friend] = []
    
    
    
    
//    회원가입
    func Register(email: String, password: String){
        // POST 로 보낼 정보
        let params:Parameters = ["email": email, "password":password]
        
        AF.request(url + "user",method: .post,parameters: params,encoding:URLEncoding.default,headers: ["Content-Type":"application/x-www-form-urlencoded"]).responseJSON { response in
            
            switch response.result {
            case .success(_):
                print("POST 성공")
                
            case .failure(let error):
                print("🚫 Register Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }

//  로그인
    func login(email:String, password: String, completion: @escaping (Bool) -> Void){

        AF.request(url + "user/login",
                   method: .post,
                   parameters: ["email":email,"password":password],
                   encoding: URLEncoding.default,
                   headers: nil)
            
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = value as! NSDictionary
                    DB.userDefaults.set(["token":json["token"], "email" : json["email"]],forKey: "token")
                    print(json["token"])
                    completion(true)


                case .failure(let error):
                    print("🚫 login Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
                    
                    completion(false)
                }
            }
    }
    

    func emailDuplicateCheck(email: String, completion: @escaping (Int) -> Void) {
        let parameters: [String: Any] = ["email": email]
        
        AF.request(url+"user/existEmail/" , method: .get, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                guard let result = data as? Int else { return }
                completion(result)
               
            case .failure(let error):
                print("🚫searchUser  Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }
    
    
//    토큰 유무 확인하여 로그인
    func loginCheck(completion: @escaping (Bool)-> Void ) {
        
        let headers: HTTPHeaders = ["Authorization" : returnToken()]
        
        AF.request(urlUser,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: headers)
            
            .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    completion(true)
                case .failure(let error):
                    print("🚫 loginCheck Error:\(error._code), Message: \(error.errorDescription!),\(error)")
                    completion(false)
                }
            }
    }
    
    func loadUserInfo(completion: @escaping (Result<UserInfo, AFError>)-> Void) {
        
        let headers: HTTPHeaders = ["Authorization" : returnToken()]
        
        AF.request(urlUser,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: headers)
            
            .responseDecodable(of: UserInfo.self) { (response) in
                switch response.result {
                case .success(_):
                    completion(response.result)
                case .failure(let error):
                    print("🚫 loadUserInfo Error:\(error._code), Message: \(error.errorDescription!),\(error)")
                }
            }
    }
    
    func loadUserInfoRx() -> Observable<UserInfo>{
        return Observable.create() { emitter in
            self.loadUserInfo() { result in
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
    
    
    func loadFriendInfo(friendId: Int ,completion: @escaping (Bool)-> Void) {

        let headers: HTTPHeaders = ["Authorization" : returnToken()]

        AF.request(url+"/user/\(friendId)",
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: headers)
            .responseDecodable(of: UserInfo.self) { response in
                switch response.result {
                case .success(_):
                    self.friendInfo.removeAll()
                    
                    self.friendInfo.append(response.value!)

                    completion(true)
                case .failure(let error):
                    print("🚫 loadUserInfo Error:\(error._code), Message: \(error.errorDescription!),\(error)")
                }
            }
    }
    
    func saveUserProfileImage(image: UIImage, imageName: String, completion: @escaping (Bool) -> Void){
        let headers: HTTPHeaders = [
                    "Content-type": "multipart/form-data",
                    "Authorization" : returnToken()
                ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image.jpegData(compressionQuality: 1)!, withName: "userImage", fileName: imageName, mimeType: "image/jpg")
            
        }, to: urlUser + "image",method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
            
            print("Upload Progress: \(progress.fractionCompleted)")
            
        }).response { response in
            switch response.result {
            case .success(_):
                completion(true)
               
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }

    func saveUserProfile(name: String, phone: String ,intro: String, public: Bool, completion: @escaping (Bool) -> Void) {
        let parameters :Parameters = ["name": name, "phone": intro]
     
        let headers: HTTPHeaders = [
                    "Content-type": "application/x-www-form-urlencoded",
                    "Authorization" : returnToken()
                ]
        
        AF.request(urlUser ,method: .put,parameters: parameters,encoding:URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(_):
                completion(true)
                
            case .failure(let error):
                print("🚫 saveUserProfile Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }
  
    func loadFollowerRx() -> Observable<[Friend]>{
        return Observable.create() { emitter in
            self.loadFollower() { result in
                    emitter.onNext(result)
                    emitter.onCompleted()
                }
            return Disposables.create()
        }
    }
    
    func loadFollower(completion: @escaping ([Friend]) -> Void){
        let headers: HTTPHeaders = [
                    "Content-type": "application/x-www-form-urlencoded",
                    "Authorization" : returnToken()
                ]
        
        AF.request(urlUser + "friend/follower" ,method: .get , encoding:URLEncoding.default, headers: headers).responseDecodable(of: Friends.self) { response in
            switch response.result {
            case .success(_):
                self.followers.removeAll()
                let data = response.value!
                
                self.followers = data.friends.map({ data in
                    return data
                })
                completion(self.followers)
            case .failure(let error):
                print("🚫 saveUserProfile Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }
    
    func loadFollowingRx() -> Observable<[Friend]>{
        return Observable.create() { emitter in
            self.loadFollowing() { result in
                    emitter.onNext(result)
                    emitter.onCompleted()
                }
            return Disposables.create()
        }
    }

    
    func loadFollowing(completion: @escaping ([Friend]) -> Void){
        let headers: HTTPHeaders = [
                    "Content-type": "application/x-www-form-urlencoded",
                    "Authorization" : returnToken()
                ]
        
        AF.request(urlUser + "friend/following" ,method: .get , encoding:URLEncoding.default, headers: headers).responseDecodable(of: Friends.self) { response in
            switch response.result {
            case .success(_):
                self.followings.removeAll()
                let data = response.value!
                
                self.followings = data.friends.map({ data in
                    return data
                })
                completion(self.followings)
                
            case .failure(let error):
                print("🚫 saveUserProfile Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }
    
    
    func loadDeleteFollowergRx(id: Int) -> Observable<Bool>{
        
        return Observable.create() { emitter in
            self.deleteFollower(id: id) { result in
                    emitter.onNext(result)
                    emitter.onCompleted()
                }
            return Disposables.create()
        }
    }
        
    func deleteFollower(id: Int, completion: @escaping ((Bool) -> Void)){
        let headers: HTTPHeaders = [
                    "Content-type": "application/x-www-form-urlencoded",
                    "Authorization" : returnToken()
                ]
        AF.request(urlUser + "friend/\(id)" ,method: .delete , encoding:URLEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success(_):
                completion(true)
            case .failure(let error):
                print("🚫 saveUserProfile Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
                completion(false)
            }
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
