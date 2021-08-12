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
    
}



class UserManager {
    var user: [User] = []
    let userDefaults = UserDefaults.standard
    
    static let shared = UserManager()
    
    func loadData(){
//        self.userDefaults.set("ww", forKey: "ww")
        let url = "http://camtorage.bamdule.com/camtorage/api/user"
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: nil)
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
    

    
    func Register(email: String, password: String){
//        지금은 HTTP가 되도록 설정해 놓음 추후에 INFO.PLIST 수정해야 한다
        let url = "http://camtorage.bamdule.com/camtorage/api/user"
        // POST 로 보낼 정보
        let params:Parameters = ["email": email, "password":password]
        
        AF.request(url,method: .post,parameters: params,encoding:URLEncoding.default,headers: ["Content-Type":"application/x-www-form-urlencoded"]).validate(statusCode: 200..<300).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                print("POST 성공")
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
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

    func loginCheck(email:String, password: String){
        let url = "http://camtorage.bamdule.com/camtorage/api/user/login"
                AF.request(url,
                           method: .post,
                           parameters: ["email":email,"password":password],
                           encoding: URLEncoding.default,
                           headers: nil)
                    .validate(statusCode: 200..<300)
                    .responseJSON { (response) in
                        switch response.result {
                        case .success(let value):
                            let json = value as! NSDictionary
                            self.userDefaults.set(["token":json["jwt"], "email" : email],forKey: "token")
                            print(self.userDefaults.dictionaryRepresentation().keys)
                            print(self.userDefaults.dictionaryRepresentation().values)
                            
                            
                            
                        case .failure(let error):
                            print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
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
}
