//
//  UserModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/07/29.
//

import Foundation
import Alamofire
import UIKit



class UserViewModel {
    
    static let shared = UserViewModel()
    
    let url = API.BASE_URL
    let urlUser = API.BASE_URL_MYSELF
    var userInfo: [UserInfo] = []
    
    
//    회원가입
    func Register(email: String, password: String){
        // POST 로 보낼 정보
        let params:Parameters = ["email": email, "password":password]
        
        AF.request(url + "user",method: .post,parameters: params,encoding:URLEncoding.default,headers: ["Content-Type":"application/x-www-form-urlencoded"]).validate(statusCode: 200..<300).responseJSON { response in
            
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
            .validate(statusCode: 200..<300)
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
    
    
//    토큰 유무 확인하여 로그인
    func loginCheck(completion: @escaping (Bool)-> Void ) {
        
        let headers: HTTPHeaders = ["Authorization" : returnToken()]
        
        AF.request(urlUser,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
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
    
    func loadUserInfo(completion: @escaping (Bool)-> Void) {
        
        let headers: HTTPHeaders = ["Authorization" : returnToken()]
        
        AF.request(urlUser,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    guard let user = response.data else { return }
                    let userData = self.parseUser(user)
                    self.userInfo.append(userData)
                    completion(true)
                case .failure(let error):
                    print("🚫 loadUserInfo Error:\(error._code), Message: \(error.errorDescription!),\(error)")
                }
            }
    }
    
    func parseUser(_ data: Data) -> UserInfo {
        let decoder = JSONDecoder()
        self.userInfo.removeAll()
        do {
            let response = try decoder.decode(UserInfo.self, from: data)
            return response
        } catch let error {
            print(AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error)))
            print("--> UserInfo parsing error: \(error.localizedDescription)")
            return UserInfo.init(code: "", user: User.init(), followerCnt: 0, followingCnt: 0, gearCnt: 0, boardCnt: 0)
        }
    }
    
    func saveUserProfileImage(image: UIImage, imageName: String){
        let headers: HTTPHeaders = [
                    "Content-type": "multipart/form-data",
                    "Authorization" : returnToken()
                ]
        
        print(image)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image.jpegData(compressionQuality: 1)!, withName: "userImage", fileName: imageName, mimeType: "image/jpg")
            
        }, to: urlUser + "image",method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
            
            print("Upload Progress: \(progress.fractionCompleted)")
            
        }).response { response in
            switch response.result {
            case .success(_):
                print(response.result)
               
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func saveUserProfile(name: String, phone: String ,intro: String, public: Bool, completion: @escaping (Bool) -> Void) {
        
        let parameters :Parameters = ["name": name, "phone": intro]
        
        let headers: HTTPHeaders = [
                    "Content-type": "application/x-www-form-urlencoded",
                    "Authorization" : returnToken()
                ]
        
        AF.request(urlUser ,method: .put,parameters: parameters,encoding:URLEncoding.default, headers: headers).validate(statusCode: 200..<300
        ).responseJSON { response in
            switch response.result {
            case .success(_):
                completion(true)
                
            case .failure(let error):
                print("🚫 saveUserProfile Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }
  
    
    func isValidEmail(email: String) -> Bool{
        // print(userDefaults.string(forKey: "ww") as! String)
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
