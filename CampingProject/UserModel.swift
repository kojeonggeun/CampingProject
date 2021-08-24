//
//  UserModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/07/29.
//

import Foundation
import Alamofire



class UserManager {
    
    let userDefaults = UserDefaults.standard
    
    static let shared = UserManager()


    

    
    func Register(email: String, password: String){
//        지금은 HTTP가 되도록 설정해 놓음 추후에 INFO.PLIST 수정해야 한다
        let url = API.BASE_URL + "user"
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
        
    
//    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
//       if let data = text.data(using: .utf8) {
//           do {
//               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
//               return json
//           } catch {
//               print("Something went wrong")
//           }
//       }
//       return nil
//   }

    func loginCheck(email:String, password: String, completion: @escaping (Bool) -> Void){
//        URLSession 코드
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
        
        
//        var request = URLRequest(url: url!)
//
//        request.httpMethod = "POST"
//
//        let body: NSMutableDictionary = NSMutableDictionary()
//        body.setValue(email, forKey: "email")
//        body.setValue(password, forKey: "password")
//
//        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.httpBody = "email=\(String(describing: body.value(forKey: "email")!))&password=\(String(describing: body.value(forKey: "password")!))".data(using: .utf8)
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//                    // 서버가 응답이 없거나 통신이 실패
//                    if let e = error {
//                      NSLog("An error has occured: \(e.localizedDescription)")
//                      return
//                    }
//
//                    // 응답 처리 로직
//                    DispatchQueue.main.async() {
//                        // 서버로부터 응답된 스트링 표시
//                        let outputStr = String(data: data!, encoding: String.Encoding.utf8)
//                        print("result: \(outputStr!)")
//                        completion(true)
//                    }
//
//                }
//                // POST 전송
//                task.resume()
        
        let url = API.BASE_URL + "user/login"
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
                    self.userDefaults.set(["token":json["token"], "email" : json["email"]],forKey: "token")
                    guard let token = self.userDefaults.value(forKey: "token") as? NSDictionary else { return }
                    print(token)
                    completion(true)


                case .failure(let error):
                    print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
                    completion(false)
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
