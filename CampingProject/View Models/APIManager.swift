//
//  APIService.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/09.
//

import Foundation
import Alamofire
import AlamofireImage

class APIManager{
    
    static let shared = APIManager()
    
    let imageCache = AutoPurgingImageCache( memoryCapacity: 111_111_111, preferredMemoryUsageAfterPurge: 90_000_000)
    let url = API.BASE_URL
    let urlUser = API.BASE_URL_MYSELF
    
    var gearTypes: [GearType] = []
    var userGears: [CellData] = []

    var friendInfo: [UserInfo] = []
    var followers: [Friend] = []
    var followings: [Friend] = []
    var userInfo: UserInfo? = nil
    
//    장비 저장
    func addGear(name: String, type: Int, color: String, company: String, capacity: String, date: String, price: String ,image: [UIImage], imageName: [String]){
        let headers: HTTPHeaders = [
                    "Content-type": "multipart/form-data",
                    "Authorization" : returnToken()
                ]
        
        let parameters: [String : Any] = ["name" : name , "gearTypeId": type,
                                          "color": color, "company": company,
                                          "capacity": capacity, "price": price,
                                          "buyDt": date
        ]
        
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                
            }
            // withName에 디비와 매칭되는 값을 넣어야함
            for i in 0..<image.count{
                multipartFormData.append(image[i].jpegData(compressionQuality: 1)!, withName: "gearImages", fileName: imageName[i],mimeType: "image/jpg")
            }
            
        }, to: urlUser + "gear",method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
            
            print("Upload Progress: \(progress.fractionCompleted)")
            
        }).responseJSON { response in
            switch response.result {
            case .success(_):
                print("")
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    장비 삭제
    func deleteGear(gearId: Int,  row: Int) {
        userGears.remove(at: row)
        
        AF.request(urlUser + "gear/\(gearId)", method: .delete,headers: self.headerInfo()).validate(statusCode: 200..<300).response { (response) in
            print(response)
        }
    }
    
//    장비 수정
    func editGear(gearId: Int,name: String, type: Int, color: String, company: String, capacity: String, date: String, price: String ,image: [UIImage], imageName: [String], item: [ImageData]){
        
        let headers: HTTPHeaders = [
                    "Content-type": "multipart/form-data",
                    "Authorization" : returnToken()]
        
        let parameters: [String : Any] = ["name" : name , "gearTypeId": type,
                                  "color": color, "company": company,
                                  "capacity": capacity, "price": price,
                                  "buyDt": date]
    
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key as String)
            }
            for (index,value) in item.enumerated() {
                multipartFormData.append("\(value.imageId)".data(using: .utf8)!, withName: "gearImages[\(index)].imageId")
            }
            
            // withName에 디비와 매칭되는 값을 넣어야함
            for i in 0..<image.count{
                multipartFormData.append(image[i].jpegData(compressionQuality: 1)!, withName: "gearImages[\(i)].image", fileName: imageName[i],mimeType: "image/jpg")
                
            }
        }, to: urlUser + "gear/\(gearId)" ,method: .put, headers: headers).uploadProgress(queue: .main, closure: { progress in

            print("Upload Progress: \(progress.fractionCompleted)")

        }).responseString { response in
            switch response.result {
            case .success(_):
                self.loadUserGear(completion: { data in
                })
            case .failure(let error):
                print(error)
            }
        }
    
    }
//    장비타입 로드
    func loadGearType(completion: @escaping (Bool) -> Void ) {
        
        AF.request(url + "common/config",
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: nil)
            .validate(statusCode: 200..<300)
            .responseDecodable(of:Response.self) { (response) in
                
                switch response.result{
                case .success:
                    let gears = response.value!
                    self.gearTypes.removeAll()
                    
                    for i in gears.gearTypes {
                        self.gearTypes.append(i)
                    }
                
                    completion(true)
                    
                case .failure(let error):
                    print(error)
                    completion(false)
                }
            }
    }

    
    
//  유저 장비 로드
    func loadUserGear(completion: @escaping (Bool) -> Void){
        AF.request(urlUser + "gear", method: .get ,encoding:URLEncoding.default, headers: self.headerInfo()).validate(statusCode: 200..<300)
            .responseDecodable(of:[CellData].self)  { (response) in
            switch response.result {
            case .success(_):
                self.userGears.removeAll()
                let userGears = response.value!
                for i in userGears {
                    self.userGears.append(i)
                }
                
                completion(true)
                
            case .failure(let error):
                print("🚫loadUserData  Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
                completion(false)
                
            }
        }
    }
    
//    유저 장비 이미지 로드
    func loadGearImages(gearId: Int, completion: @escaping ([ImageData]) -> Void){
        
        AF.request(urlUser + "gear"+"/images/\(gearId)", method: .get, headers: self.headerInfo()).validate(statusCode: 200..<300)
            .responseDecodable(of:[ImageData].self)  { (response) in
    
            switch response.result {
            case .success(_):
                
                let images = response.value!
                if !images.isEmpty{
                    AF.request(images[0].url).responseImage { response in
                        if response.value != nil{
                            let image = UIImage(data: response.data!)!
                            self.imageCache.add(image, withIdentifier: "\(gearId)")
                        }
                    }
                } else {
                    let image = UIImage(systemName:"camera.circle")!
                    self.imageCache.add(image, withIdentifier: "\(gearId)")
                }
          
                completion(images)
        
            case .failure(let error):
                print("🚫loadGearImages  Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            } // end switch
        }
        
    }
    
    func loadSearchUserGear(id: Int) {
        AF.request(url + "gear"+"/\(id)", method: .get, headers: self.headerInfo()).validate(statusCode: 200..<300)
            .responseDecodable(of:[CellData].self)  { (response) in
            switch response.result {
            case .success(_):
                print(id)
                for i in response.value! {
                    self.loadGearImages(gearId: i.id, completion: { data in
                        print(data)
                    })
                }
            case .failure(let error):
                print("🚫loadSearchUserGear  Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }

//    유저 검색
    func searchUser(searchText: String, page: Int = 0, completion: @escaping ([SearchUser]) -> Void){
        let parameters: [String: Any] = ["searchText": searchText, "page": page, "size": 5]
        
        AF.request(url+"user/search/" , method: .get, parameters: parameters, headers: self.headerInfo()).validate(statusCode: 200..<300)
            .responseDecodable(of: SearchResult.self) { (response) in
            switch response.result {
            case .success(let data):
                let searchResult = response.value!
                completion(searchResult.users)
               
            case .failure(let error):
                print("🚫searchUser  Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }
    
    
    
/*
    친구를 요청하게 되면 계정 공개일 경우
    팔로잉 추가, 상대방은 팔로워 추가
    비공개 일 경우 요청 & 승인 과정을 거쳐야 함
*/
    func followRequst(id: Int, isPublic: Bool, completion: @escaping (Bool) -> Void){
        
        AF.request(urlUser + "friend/\(id)",
                   method: .post,
                   encoding:JSONEncoding.default,
                   headers: self.headerInfo())
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    completion(true)
                   
                case .failure(let error):
                    print(AFError.parameterEncodingFailed(reason: .customEncodingFailed(error: error)))
                    print("🚫 followRequst Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
                    completion(false)
                }
            }
    }
    
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
    
// 이메일 중복검사
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
//    유저 정보 로드
    func loadUserInfo(completion: @escaping (Result<UserInfo, AFError>)-> Void) {
        
        let headers: HTTPHeaders = ["Authorization" : returnToken()]
        
        AF.request(urlUser,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: headers)
            
            .responseDecodable(of: UserInfo.self) { (response) in
                switch response.result {
                case .success(_):
                    self.userInfo = response.value!
                    
                    completion(response.result)
                case .failure(let error):
                    print("🚫 loadUserInfo Error:\(error._code), Message: \(error.errorDescription!),\(error)")
                }
            }
    }
//    친구 정보 로드
    func loadFriendInfo(friendId: Int ,completion: @escaping (Result<UserInfo, AFError>)-> Void) {

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

                    completion(response.result)
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

    func saveUserProfile(name: String, phone: String ,aboutMe: String, public: Bool, completion: @escaping (Bool) -> Void) {
        let parameters :Parameters = ["name": name, "aboutMe": aboutMe]
     
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
                print("🚫 loadFollower Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
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
                print("🚫 loadFollowing Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
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
                print("🚫 deleteFollower Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
                completion(false)
            }
        }
    }
    
//    API herder
    func headerInfo() -> HTTPHeaders {
        
        let headers: HTTPHeaders = [
                "Content-Type" : "application/x-www-form-urlencoded",
                "Authorization" : returnToken(),
                ]
            
        return headers
        
    }
    
    func returnToken() -> String{
        let tokenDict =  DB.userDefaults.value(forKey: "token") as! NSDictionary
        let token = tokenDict["token"] as! String
        
        
        return token
    }

}
