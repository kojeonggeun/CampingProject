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
    
    private let gears = BehaviorRelay<[CellData]>(value: [])
    var gearObservable: Observable<[CellData]> {
        return gears.asObservable()
    }
    
    private let gearImage = PublishRelay<[UIImage]>()
    var gearImageObservable: Observable<[UIImage]> {
        return gearImage.asObservable()
    }
    
    let disposeBag = DisposeBag()
    
    init() {
        loadGears()
    }
    
    func loadGears(){
        userVM.loadUserGearRx()
            .subscribe(onNext: { data in
                self.gears.accept(data)
            }).disposed(by: disposeBag)
    }
    
    func loadimage(image: [UIImage]) {
        print(image)
        gearImage.accept(image)
    }
    
}

