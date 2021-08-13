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
    
    
}
