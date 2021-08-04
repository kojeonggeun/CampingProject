//
//  UserModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/07/29.
//

import Foundation
import Alamofire


struct User: Codable {
    var id: String
    var email: String
    var password: String
}

class UserManager {
    var user: [User] = []
    
    
    func loadData(){
        let url = "http://127.0.0.1:8080/api/users"
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result{
                case .success:
                    guard let result = response.data else {return}
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode([User].self, from: result)
                        for i in json{
                            self.user.append(i)
                        }
                    } catch {
                        print("error!\(error)") } default: return }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool)-> Void) {
            let url = "http://127.0.0.1:8080/api/users"
            var check: Bool = false
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
                .validate(statusCode: 200..<300)
                .responseJSON { (response) in
                    switch response.result{
                    case .success:
                        guard let result = response.data else {return}
                        do {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode([User].self, from: result)
                            completion(check)
                            
                            
                        } catch {
                            print("error!\(error)") } default: return }
            }
        }
    
    func Register(email: String, password: String){
        let url = "http://127.0.0.1:8080/api/users"
        // POST 로 보낼 정보
        let params:Parameters = ["email": email, "password":password]

        AF.request(url,method: .post,parameters: params,encoding:JSONEncoding.default,headers: nil).validate(statusCode: 200..<300).responseData { response in
            
            switch response.result {
            case .success:
                print("POST 성공")
                print(response)
//                let a = String(data: value, encoding: .utf8)!
//                print(a.split(separator: ":")[1])
//            guard let result = response.data else {return}
//            print(result)
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
  
    
    
    func loginCheck(email:String, password: String) -> Bool{
        return true
    }
   
 
}


class UserAPI {
    // 로그인 결과를 나타낸다.
    // email, password 입력받아 , 검증 후 bool값을 Completion으로 넘김
    
   
    
}
