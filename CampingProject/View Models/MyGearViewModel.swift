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
    
    let store = Store.shared
    let apiManager = APIManager.shared
    let disposeBag = DisposeBag()
    
    struct Input {
        let loadGears: PublishSubject<Void> = PublishSubject<Void>()
        let didSelectCell: Driver<ViewGear>
    }
    
    struct Output {
        let didSelectCell: Driver<ViewGear>
        
    }
    
    private let _gears = BehaviorRelay<[CellData]>(value: [])
    private let _gearTypes = BehaviorRelay<[GearType]>(value: [])
    
    
    public var gears: Observable<[CellData]> {
        return _gears.asObservable()
    }
    
    public var gearTypes: Observable<[GearType]> {
        return _gearTypes.asObservable()
    }
    
    init() {
        apiManager.loadGearType().map{ $0 }.subscribe(onNext:{
            self._gearTypes.accept($0)
        }).disposed(by: disposeBag)
        
        loadGears()
    }
    
    func loadGears(){
        store.loadUserGearRx().map{ $0 }.subscribe(onNext:{
            self._gears.accept($0)
        }).disposed(by: disposeBag)
    
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.loadGears
            .subscribe({_ in 
                print("123123")
            })
        let didSelectCell = input.didSelectCell.do(onNext: { [weak self] gearId in })

        return Output(didSelectCell: didSelectCell)
    }
    
}

