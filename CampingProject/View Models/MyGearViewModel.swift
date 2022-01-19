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
    
    private let gears = BehaviorRelay<[CellData]>(value: [])
    var gearObservable: Observable<[CellData]> {
        return gears.asObservable()
    }
    
    private let gearImage = BehaviorRelay<[UIImage]>(value: [])
    var gearImageObservable: Observable<[UIImage]> {
        return gearImage.asObservable()
    }
    
    private let gearTypes = PublishRelay<[GearType]>()
    var gearTypeeObservable: Observable<[GearType]> {
        return gearTypes.asObservable()
    }
    
    let disposeBag = DisposeBag()
    
    init() {
        self.apiManager.loadGearType(completion: { [self] data in
            if data {
                gearTypes.accept(self.apiManager.gearTypes)
            }
        })
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
    
}

