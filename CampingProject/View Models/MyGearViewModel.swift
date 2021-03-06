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

public protocol MyGearInput {
    func loadGears()
    func loadGearTypes()
}
public protocol MyGearOutput {
    var gears: Observable<[CellData]> { get }
    var gearTypes: Observable<[GearType]> { get }
}

public protocol MyGearViewModelType {
    var inputs: MyGearInput { get }
    var outputs: MyGearOutput { get }

}

class MyGearViewModel: MyGearInput, MyGearOutput, MyGearViewModelType {
    private let store = Store.shared
    private let apiManager = APIManager.shared
    private let disposeBag = DisposeBag()

    private let _gears = BehaviorRelay<[CellData]>(value: [])
    private let _gearTypes = BehaviorRelay<[GearType]>(value: [])
 
    var gears: Observable<[CellData]> {
        return _gears.asObservable()
    }

    var gearTypes: Observable<[GearType]> {
        return _gearTypes.asObservable()
    }

    func loadGears() {
        store.loadUserInfoRx()
            .subscribe()
            .disposed(by: disposeBag)
        
        store.loadUserGearRx()
            .subscribe(onNext: {
                self._gears.accept($0)
            })
            .disposed(by: disposeBag)
    }

    func loadGearTypes() {
        apiManager.loadConfig()
            .map { $0.gearTypes }
            .subscribe(onNext: {
                self._gearTypes.accept($0)
            }).disposed(by: disposeBag)
    }

    var inputs: MyGearInput { return self }
    var outputs: MyGearOutput { return self }
}
