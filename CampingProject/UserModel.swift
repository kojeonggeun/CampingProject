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
    
    static let shared = UserManager()
    
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
    
//    func login(email: String, password: String, completion: @escaping (Bool)-> Void) {
//            let url = "http://127.0.0.1:8080/api/users"
//            var check: Bool = false
//            AF.request(url,
//                       method: .get,
//                       parameters: nil,
//                       encoding: URLEncoding.default,
//                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
//                .validate(statusCode: 200..<300)
//                .responseJSON { (response) in
//                    switch response.result{
//                    case .success:
//                        guard let result = response.data else {return}
//                        do {
//                            let decoder = JSONDecoder()
//                            let json = try decoder.decode([User].self, from: result)
//                            completion(check)
//
//
//                        } catch {
//                            print("error!\(error)") } default: return }
//            }
//        }
    
    func Register(email: String, password: String){
        let url = "http://127.0.0.1:8080/api/users"
        // POST 로 보낼 정보
        let params:Parameters = ["email": email, "password":password]
        
        AF.request(url,method: .post,parameters: params,encoding:JSONEncoding.default,headers: nil).validate(statusCode: 200..<300).responseData { response in
            
            switch response.result {
            case .success(let value):
                print("POST 성공")
                
                guard let data = String(data: value, encoding: .utf8) else { return }
                let jsonData = self.convertStringToDictionary(text: data)
                guard let userData = jsonData as? [String: String] else { return }
                
                self.user.append(User(id: userData["id"]!, email: userData["email"]!, password: userData["password"]!))
                
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
  
    
    
    func loginCheck(email:String, password: String) -> Bool{
        for i in user{
            if i.email == email && AES256Util.decrypt(encoded: i.password) == password {
                return true
            }
        }
        return false
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
}
