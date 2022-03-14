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
    private let _viewGear = PublishRelay<ViewGear>()

    var didSelectViewGear: Observable<ViewGear> {
        return _viewGear.asObservable()
    }

    var gears: Observable<[CellData]> {
        return _gears.asObservable()
    }

    var gearTypes: Observable<[GearType]> {
        return _gearTypes.asObservable()
    }

    func loadGears() {
        store.loadUserInfoRx()
            .subscribe(onNext: { _ in})
            .disposed(by: disposeBag)
        
        store.loadUserGearRx().map { $0 }.subscribe(onNext: {
            self._gears.accept($0)
        })
        .disposed(by: disposeBag)
    }

    func loadGearTypes() {
        apiManager.loadGearType().map { $0 }.subscribe(onNext: {
            self._gearTypes.accept($0)
        })
        .disposed(by: disposeBag)
    }

    var inputs: MyGearInput { return self }
    var outputs: MyGearOutput { return self }
}
