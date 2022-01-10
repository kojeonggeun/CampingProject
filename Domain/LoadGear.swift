//
//  LoadGear.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/10.
//

import Foundation
import RxSwift

protocol GearFetchable {
    func fetchGears() -> Observable<[CellData]>
    
}

class LoadGear: GearFetchable {
    func fetchGears() -> Observable<[CellData]> {
        return APIManager2.loadUserGearRx()
            .map{ data in
                return data
            }
            
    }
}
