//
//  MyGearViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/06.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa

class MyGearViewModel {

    static let shared = MyGearViewModel()
    let userVM = UserViewModel.shared
    let apiManager = APIManager.shared
    let disposeBag = DisposeBag()
    
    private let gears = BehaviorRelay<[CellData]>(value: [])
    private let gearImage = BehaviorRelay<[UIImage]>(value: [])
    private let gearTypes = BehaviorRelay<[GearType]>(value: [])
    private let gearDetail = PublishSubject<Void>()
    
    let gearDetailObserver: AnyObserver<Void>
    
    var gearObservable: Observable<[CellData]> {
        return gears.asObservable()
    }
    var gearImageObservable: Observable<[UIImage]> {
        return gearImage.asObservable()
    }
    var gearTypeObservable: Observable<[GearType]> {
        return gearTypes.asObservable()
    }
    
        
    init() {
        
        gearDetailObserver = gearDetail.asObserver()
       
        gearDetail
            .flatMap(userVM.loadDetailUserGearRx2)
        
        loadGearType()
    }
    
    func loadGears(){
        userVM.loadUserGearRx()
            .subscribe(onNext: { data in
                self.gears.accept(data)
            }).disposed(by: disposeBag)
    }
    
    func loadimage(image: [UIImage]) {
        gearImage.accept(image)
    }
    
    func loadGearType(){
        self.apiManager.loadGearType(completion: {  data in
            if data {
                self.gearTypes.accept(self.apiManager.gearTypes)
            }
        })
    }
    
    func asd(){
        
        let userId = apiManager.userInfo?.user?.id
        
      
    }
}

