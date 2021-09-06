//
//  GearModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/12.
//

import Foundation
import Alamofire

class GearManager{
    
    let userDefaults = UserDefaults.standard
    static let shared = GearManager()
    
    var gears: [GearType] = []
    var userGear: [CellData] = []
    
    let url = API.BASE_URL_MYSELF
    let urlUser = API.BASE_URL
    
    func loadGearType(completion: @escaping ([GearType]) -> ()) {
        
        AF.request(urlUser + "common/config",
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
        self.gears = []

        do {
            let response = try decoder.decode(Response.self, from: data)
            let gears = response.gearTypes
            return gears
   
        } catch let error {
            print("--> GearType parsing error: \(error.localizedDescription)")
          
        }
        return []
    }
    
    
    func gearSave(name: String, type: Int, color: String, company: String, capacity: String, price: String ,image: [UIImage], imageName: [String]){
        // 먼저 image를 Data형식으로 바꿔줘야 한다.
        // jpegData or pngData를 통해서 바꿔주고
        // multipartFormData에 바꾼 Data타입의 이미지를 append해준다.
      
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
            
        }, to: url + "gear",method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
            
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
    
    func loadUserData(){

        AF.request(url + "gear", method: .get ,encoding:URLEncoding.default, headers: self.headerInfo()).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let result = response.data else { return }

                let data = self.parseUserGear(result)
                for i in data {
                    self.userGear.append(i)
                }
            case .failure(let error):
                print("🚫loadUserData  Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
    }
    func parseUserGear(_ data: Data) -> [CellData] {
        let decoder = JSONDecoder()
        self.userGear = []

        do {
            let response = try decoder.decode([CellData].self, from: data)
            
            return response
            
        } catch let error {
            print("--> CellData parsing error: \(error.localizedDescription)")
            return []
        }
        
    }
    
    
    func deleteGear(gearId: Int) {
        
        AF.request(url + "gear"+"/\(gearId)", method: .delete,headers: self.headerInfo()).validate(statusCode: 200..<300).response { (response) in
            print(response)
        }
    }
    
    func loadGearImages(gearId: Int, completion: @escaping ([ImageData]) -> Void){

        AF.request(url + "gear"+"/images/\(gearId)", method: .get, headers: self.headerInfo()).validate(statusCode: 200..<300).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let result = response.data else { return }
                completion(self.parseGearImages(result))
                
            case .failure(let error):
                print("🚫loadGearImages  Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!),\(error)")
            }
        }
        
    }
    func parseGearImages(_ data: Data) -> [ImageData] {
        let decoder = JSONDecoder()
 
        do {
            let response = try decoder.decode([ImageData].self, from: data)
            return response
        } catch let error {
            print("--> CellData parsing error: \(error.localizedDescription)")
            return []
        }
    }
    
    func headerInfo() -> HTTPHeaders {
        if let token = userDefaults.value(forKey: "token") as? NSDictionary  {
            
            let headers: HTTPHeaders = [
                        "Authorization" : token["token"] as! String
                    ]
            return headers
        } else {
            
            return HTTPHeaders()
        }
    }
    
}
