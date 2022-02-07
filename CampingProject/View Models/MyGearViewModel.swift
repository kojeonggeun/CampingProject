//
//  MyGearViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/06.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class MyGearViewModel {

    static let shared = MyGearViewModel()
    let store = Store.shared
    let apiManager = APIManager.shared
    let disposeBag = DisposeBag()
    
    private let gears = BehaviorRelay<[CellData]>(value: [])
    private let gearTypes = BehaviorRelay<[GearType]>(value: [])
    
    var gearObservable: Observable<[CellData]> {
        return gears.asObservable()
    }
    var gearTypeObservable: Observable<[GearType]> {
        return gearTypes.asObservable()
    }
    
        
    init() {
    
        loadGearType()
    }
    
    func loadGears(){
        store.loadUserGearRx()
            .subscribe(onNext: { data in
                self.gears.accept(data)
            }).disposed(by: disposeBag)
    }


    func loadGearType(){
        self.apiManager.loadGearType(completion: {  data in
            if data {
                self.gearTypes.accept(self.apiManager.gearTypes)
            }
        })
    }

}

