//
//  APIService.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/09.
//

import Foundation
import Alamofire
import RxSwift

public class APIManager {

    static let shared = APIManager()

    let url = API.BaseUrl
    let urlMyself = API.BaseUrlMyself
    var gearTypes: [GearType] = []
    var userInfo: UserInfo?

//    장비 저장
    func addGear(name: String, type: Int, color: String, company: String, capacity: String, date: String, price: String, desc:String ,image: [UIImage], imageName: [String]) -> Observable<Void> {
        return Observable.create { emitter in
            let headers: HTTPHeaders = [
                        "Content-type": "multipart/form-data",
                        "Authorization": self.returnToken()
                    ]

            let parameters: [String: Any] = ["name": name, "gearTypeId": type,
                                              "color": color, "company": company,
                                              "capacity": capacity, "price": price,
                                             "buyDt": date, "description":desc
            ]

            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)

                }
                // withName에 키값 매칭되는 값을 넣어야함
                for num in 0..<image.count {
                    multipartFormData.append(image[num].jpegData(compressionQuality: 1)!, withName: "gearImages", fileName: imageName[num], mimeType: "image/jpg")
                }

            }, to: self.urlMyself + "gear", method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in

                print("Upload Progress: \(progress.fractionCompleted)")

            }).response { response in
                switch response.result {
                case .success:

                    emitter.onNext(())
                    emitter.onCompleted()
                case .failure(let error):
                    print(error)
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }

//    장비 삭제
    func deleteGear(gearId: Int) {

        AF.request(urlMyself + "gear/\(gearId)", method: .delete, headers: self.headerInfo()).validate(statusCode: 200..<300).response { (_) in
            NotificationCenter.default.post(name: .delete, object: nil)
        }
    }

//    장비 수정
    func editGear(gearId: Int, name: String, type: Int, color: String, company: String, capacity: String, date: String, price: String, desc: String, image: [UIImage], imageName: [String], item: [ImageData]) -> Observable<Void> {
        return Observable.create { emitter in
            let headers: HTTPHeaders = [
                        "Content-type": "multipart/form-data",
                        "Authorization": self.returnToken()]

            let parameters: [String: Any] = ["name": name, "gearTypeId": type,
                                      "color": color, "company": company,
                                              "capacity": capacity, "price": price, "description": desc,
                                      "buyDt": date]

            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key as String)
                }
                for (index, value) in item.enumerated() {

                    multipartFormData.append("\(value.imageId)".data(using: .utf8)!, withName: "gearImages[\(index)].imageId")
                }

                // withName에 디비와 매칭되는 값을 넣어야함
                for num in 0..<image.count {
                    multipartFormData.append(image[num].jpegData(compressionQuality: 1)!, withName: "gearImages[\(num)].image", fileName: imageName[num], mimeType: "image/jpg")

                }
            }, to: self.urlMyself + "gear/\(gearId)", method: .put, headers: headers).uploadProgress(queue: .main, closure: { progress in

                print("Upload Progress: \(progress.fractionCompleted)")

            }).responseString { response in
                switch response.result {
                case .success:

                    emitter.onNext(())
                    emitter.onCompleted()
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }

    }
//    장비타입 로드
    func loadGearType() -> Observable<[GearType]> {
        return Observable.create { emitter in
            AF.request(self.url + "common/config",
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: nil)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Response.self) { (response) in

                    switch response.result {
                    case .success:
                        let gears = response.value!
                        self.gearTypes.removeAll()

                        for type in gears.gearTypes {
                            self.gearTypes.append(type)
                        }
                        emitter.onNext(self.gearTypes)
                        emitter.onCompleted()
                    case .failure(let error):
                        print(error)
                        emitter.onError(error)

                    }
                }
            return Disposables.create()
        }
    }

//  내 장비 로드
    func loadUserGear(completion: @escaping (Result<[CellData], AFError>) -> Void) {
        AF.request(urlMyself + "gear", method: .get, encoding: URLEncoding.default, headers: self.headerInfo()).validate(statusCode: 200..<300)
            .responseDecodable(of: [CellData].self) { (response) in
            switch response.result {
            case .success:
                
                completion(response.result)

            case .failure(let error):
                print("🚫loadUserData  Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")

            }
        }
    }
//    내 장비 상세
    func loadDetailUserGear(userId: Int, gearId: Int, completion: @escaping (Result<GearDetail, AFError>) -> Void) {
        AF.request(url + "user/\(userId)/gear/\(gearId)", method: .get, encoding: URLEncoding.default, headers: self.headerInfo()).validate(statusCode: 200..<300)
            .responseDecodable(of: GearDetail.self) { (response) in
            switch response.result {
            case .success:

                completion(response.result)

            case .failure(let error):
                print("🚫loadDetailUserGear  Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")

            }
        }
    }
// 유저장비검색
    func loadSearchUserGear(id: Int, completion: @escaping ([CellData]) -> Void ) {
        AF.request(url + "user/\(id)/gear", method: .get, headers: self.headerInfo()).validate(statusCode: 200..<300)
            .responseDecodable(of: [CellData].self) { (response) in
            switch response.result {
            case .success:

                completion(response.value!)

            case .failure(let error):
                print("🚫loadSearchUserGear  Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }

//    유저 검색
    func searchUser(searchText: String, page: Int = 0, completion: @escaping (Result<SearchResult, AFError>) -> Void) {
        let parameters: [String: Any] = ["searchText": searchText, "page": page, "size": 10]

        AF.request(url+"user/search/", method: .get, parameters: parameters, headers: self.headerInfo()).validate(statusCode: 200..<300)
            .responseDecodable(of: SearchResult.self) { (response) in
            switch response.result {
            case .success:
                completion(response.result)

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
    func followRequst(id: Int, isPublic: Bool, completion: @escaping (Bool) -> Void) {
        AF.request(urlMyself + "friend/\(id)",
                   method: .post,
                   encoding: JSONEncoding.default,
                   headers: self.headerInfo())
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    completion(true)

                case .failure(let error):
                    print(AFError.parameterEncodingFailed(reason: .customEncodingFailed(error: error)))
                    print("🚫 followRequst Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
                    completion(false)
                }
            }
    }

//    회원가입
    func register(email: String, password: String, name: String) {
        // POST 로 보낼 정보
        let params: Parameters = ["email": email, "password": password, "name": name]

        AF.request(url + "user", method: .post, parameters: params, encoding: URLEncoding.default, headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseJSON { response in

            switch response.result {
            case .success:
                print("POST 성공")

            case .failure(let error):
                print("🚫 Register Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }

//  로그인
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {

        AF.request(url + "user/login",
                   method: .post,
                   parameters: ["email": email, "password": password],
                   encoding: URLEncoding.default,
                   headers: nil)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Login.self) { (response) in
                switch response.result {
                case .success(let value):
                    print(value.token)
                    DB.userDefaults.set(["token": value.token, "email": value.email], forKey: "token")
                    print(DB.userDefaults.value(forKey: "token"))
                    completion(true)
                case .failure(let error):
                    print("🚫 login Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
                    completion(false)
                }
            }
    }
//  회원 탈퇴
    func disregister(){
        AF.request(urlMyself, method: .delete, encoding: URLEncoding.default, headers: headerInfo()).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print("🚫 Register Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }
    
   
    
//    비밀번호 인증
    func passwordCertification(password: String, completion: @escaping (Bool) -> Void){
        let params: Parameters = ["password": password]
        
        AF.request(urlMyself + "password/certification", method: .post, parameters: params, encoding: URLEncoding.default, headers: headerInfo()).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success(let data):
                completion(true)
            case .failure(let error):
                completion(false)
                print("🚫 Register Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }
    
    

// 이메일 중복검사
    func checkEmailDuplicate(email: String, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = ["email": email]

        AF.request(url+"user/existEmail/", method: .get, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                guard let result = data as? Bool else { return }
                completion(result)

            case .failure(let error):
                print("🚫searchUser  Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }

//    토큰 유무 확인하여 로그인
    func loginCheck(completion: @escaping (Bool) -> Void ) {
        
        AF.request(urlMyself,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: headerInfo())
            .responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    guard let result = data as? NSDictionary else {return}
                    if result["error"] != nil {
                        completion(false)
                    } else {
                        completion(true)
                    }
                case .failure(let error):
                    print("🚫 loginCheck Error:\(error._code), Message: \(error.errorDescription!),\(error)")
                    completion(false)
                }
            }
    }
//    유저 정보 로드
    func loadUserInfo(completion: @escaping (Result<UserInfo, AFError>) -> Void) {
        
        AF.request(urlMyself,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: headerInfo())

            .responseDecodable(of: UserInfo.self) { (response) in
                switch response.result {
                case .success:
                    self.userInfo = response.value!
                    completion(response.result)
                case .failure(let error):
                    print("🚫 loadUserInfo Error:\(error._code), Message: \(error.errorDescription!),\(error)")
                }
            }
    }
    
    func changePassword(password: String){
            let parameters: Parameters = ["password": password]

            AF.request(self.urlMyself + "password", method: .put, parameters: parameters, encoding: URLEncoding.default, headers: self.headerInfo()).response { response in
                switch response.result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    
                    print("🚫 saveUserProfile Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
                }
            }
    }
    
//    친구 정보 로드
    func loadFriendInfo(friendId: Int, completion: @escaping (Result<UserInfo, AFError>) -> Void) {

        

        AF.request(url+"/user/\(friendId)",
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: headerInfo())
            .responseDecodable(of: UserInfo.self) { response in
                switch response.result {
                case .success:

                    completion(response.result)
                case .failure(let error):
                    print("🚫 loadUserInfo Error:\(error._code), Message: \(error.errorDescription!),\(error)")
                }
            }
    }

    func saveUserProfileImage(image: UIImage, imageName: String, completion: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
                    "Content-type": "multipart/form-data",
                    "Authorization": returnToken()
                ]

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image.jpegData(compressionQuality: 1)!, withName: "userImage", fileName: imageName, mimeType: "image/jpg")

        }, to: urlMyself + "image", method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in

            print("Upload Progress: \(progress.fractionCompleted)")

        }).response { response in
            switch response.result {
            case .success:

                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }

    func saveUserProfile(name: String, phone: String, aboutMe: String, public: Bool, completion: @escaping (Bool) -> Void) {
        let parameters: Parameters = ["name": name, "aboutMe": aboutMe]

        AF.request(urlMyself, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: headerInfo()).responseJSON { response in
            switch response.result {
            case .success:
                
                completion(true)
            case .failure(let error):
                print("🚫 saveUserProfile Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }

    func loadFollower(searchText: String, page: Int = 0, completion: @escaping (Result<Friends, AFError>) -> Void) {
        let parameters: [String: Any] = ["searchText": searchText, "page": page, "size": 10]
        AF.request(urlMyself + "friend/follower/", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headerInfo()).responseDecodable(of: Friends.self) { response in
            switch response.result {
            case .success:
                completion(response.result)
            case .failure(let error):
                print("🚫 loadFollower Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }

    func loadFollowing(searchText: String, page: Int = 0, completion: @escaping (Result<Friends, AFError>) -> Void) {
        let parameters: [String: Any] = ["searchText": searchText, "page": page, "size": 10]

        AF.request(urlMyself + "friend/following/", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headerInfo()).responseDecodable(of: Friends.self) { response in
            switch response.result {
            case .success:
                completion(response.result)
            case .failure(let error):
                print("🚫 loadFollowing Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }

    func deleteFollower(id: Int, completion: @escaping ((Bool) -> Void)) {

        AF.request(urlMyself + "friend/\(id)", method: .delete, encoding: URLEncoding.default, headers: headerInfo()).response { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print("🚫 deleteFollower Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
                completion(false)
            }
        }
    }

    func requestEmailCertificationCode(email: String,type: emailType, completion: @escaping (Bool) -> Void) {
        let parameter: Parameters = ["email": email, "emailCertificationType": type.rawValue]
        let headers: HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded"
                ]

        AF.request(url + "certification/email", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print("🚫 deleteFollower Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
                completion(false)

            }
        }
    }

    func checkEmailCertificationCode(email: String, code: String,type:emailType, completion: @escaping (Bool) -> Void) {
        let parameter: Parameters = ["email": email, "code": code, "emailCertificationType": type.rawValue]
    
        let headers: HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded"
                ]
        AF.request(url + "certification/email/validation", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<300)
            .response { response in
            switch response.result {
            case .success:

                completion(true)

            case .failure(let error):
                print("🚫 checkEmail Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
                completion(false)
            }
        }
    }

//    API herder
    func headerInfo() -> HTTPHeaders {

        let headers: HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded",
                "Authorization": returnToken()
                ]

        return headers

    }

    func returnToken() -> String {
        guard let tokenDict =  DB.userDefaults.value(forKey: "token") as? NSDictionary else {return ""}
        guard let token = tokenDict["token"] as? String else {return ""}

        return token
    }
    func isValidEmail(email: String) -> Bool {
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
}
