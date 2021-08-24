//
//  GearModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/12.
//

import Foundation
import Alamofire



class GearManager{
  
    static let shared = GearManager()
    
    let userDefaults = UserDefaults.standard
    var gears: [GearType] = []
    var userGear: [CellData] = []
    let semaphore = DispatchSemaphore(value: 0)
    
    func loadGearType(completion: @escaping ([GearType]) -> ()) {
        let url = API.BASE_URL + "common/config"
        
        
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
                    let data = self.parseGears(result)
                    for i in data {
                        self.gears.append(i)
                    }
                    completion(self.gears)
                    
                case .failure(let error):
                    print(error)
                }
            
            }
    
    }
    
    func parseGears(_ data: Data) -> [GearType]  {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(Response.self, from: data)
            let gears = response.gearTypes
            return gears
   
        } catch let error {
            print("--> parsing error: \(error.localizedDescription)")
          
        }
        return []
    }
    
    
    func gearSave(name: String, type: Int, color: String, company: String, capacity: String, price: String ,image: [UIImage], imageName: [String]){
        // 먼저 image를 Data형식으로 바꿔줘야 한다.
        // jpegData or pngData를 통해서 바꿔주고
        // multipartFormData에 바꾼 Data타입의 이미지를 append해준다.
        
        let url = API.BASE_URL + "gear"
        guard let token = userDefaults.value(forKey: "token") as? NSDictionary else { return }
        let headers: HTTPHeaders = [
                    "Content-type": "multipart/form-data",
                    "Authorization" : token["token"] as! String
                ]
        
        let parameters: [String : Any] = ["name" : name , "gearTypeId": type,
                                          "color": color, "company": company,
                                          "capacity": capacity, "price": price
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                
            }
            // withName에 디비와 매칭되는 값을 넣어야함
            for i in 0..<image.count{
                multipartFormData.append(image[i].jpegData(compressionQuality: 1)!, withName: "gearImages", fileName: imageName[i],mimeType: "image/jpg")
            }
            
        }, to: url,method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
            
            print("Upload Progress: \(progress.fractionCompleted)")
            
        }).responseJSON { response in
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func loadUserData(completion: @escaping (Bool) -> ()){
        let url = API.BASE_URL + "gear"
        guard let token = userDefaults.value(forKey: "token") as? NSDictionary else { return }
        
        let headers: HTTPHeaders = [
                    "Authorization" : token["token"] as! String
                ]
        
        AF.request(url, method: .get ,encoding:URLEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let result = response.data else { return }
                print(value)
                let data = self.parseUserGear(result)
               
                for i in data {
                    self.userGear.append(i)
                }
                completion(true)
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }
    
    func parseUserGear(_ data: Data) -> [CellData] {
        let decoder = JSONDecoder()
        do {
            
            let response = try decoder.decode([CellData].self, from: data)
            return response
            
        } catch let error {
            print("--> parsing error: \(error.localizedDescription)")
            return []
        }
        
    }
    
    
    
}
