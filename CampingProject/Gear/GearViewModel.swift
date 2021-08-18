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
    
    func loadGearType() {
        let url = "https://camtorage.bamdule.com/camtorage/api/common/config"
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
                    self.parseGears(result)
                  
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func parseGears(_ data: Data)  {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(Response.self, from: data)
            let gears = response.gearTypes
            for i in gears {
                self.gears.append(i)
            }
   
        } catch let error {
            print("--> parsing error: \(error.localizedDescription)")
          
        }
    }
    
    
    func gearSave(name: String, type: Int, color: String, company: String, capacity: String, image: [UIImage] ){
        // 먼저 image를 Data형식으로 바꿔줘야 한다.
        // jpegData or pngData를 통해서 바꿔주고
        // multipartFormData에 바꾼 Data타입의 이미지를 append해준다.
        
        let url = "https://camtorage.bamdule.com/camtorage/api/gear"
        guard let token = userDefaults.value(forKey: "token") as? NSDictionary else { return }
        let headers: HTTPHeaders = [
                    "Content-type": "multipart/form-data",
                    "Authorization" : token["token"] as! String
                ]
        let parameters: [String : Any] = ["name" : name , "gearTypeId": type,
                                          "color": color, "company": company,
                                          "capacity": capacity
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                
            }
            // withName에 디비와 매칭되는 값을 넣어야함
            for i in image{
                multipartFormData.append(i.jpegData(compressionQuality: 1)!, withName: "gearImages", fileName: "image.jpg",mimeType: "image/jpg")
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
    
    
}
