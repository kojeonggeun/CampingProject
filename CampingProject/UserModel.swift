//
//  UserModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/07/29.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

struct User: Codable {
    var id: String
    var email: String
    var password: String
    
}


// 분리 해야 함
class UserAPI {
    
    // 로그인 결과를 나타낸다.
    // email, password 입력받아 , 검증 후 bool값을 Completion으로 넘김
    static func loginResult(email: String, password: String, completion: @escaping (Bool)-> Void) {
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

                            for i in json{
                                if email == i.email{
                                    check = true
                                    break
                                } else{
                                    check = false
                                }
                            }
                            completion(check)
                            
                        } catch {
                            print("error!\(error)") } default: return }
            }
        }
}


