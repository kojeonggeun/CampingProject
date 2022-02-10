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
   
    struct Input {
        let loadGears: PublishSubject<Void> = PublishSubject<Void>()
        let didSelectCell: Driver<ViewGear>
    }
    
    struct Output {
        let gearObservable: BehaviorRelay<[CellData]>
        let gearTypeObservable: BehaviorRelay<[GearType]>
        let didSelectCell: Driver<ViewGear>
        
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let gears = BehaviorRelay<[CellData]>(value: [])
        let gearTypes = BehaviorRelay<[GearType]>(value: [])
        
        input.loadGears
            .subscribe(onNext: {[weak self] _ in
                 self?.store.loadUserGearRx().map{ $0 }.subscribe(onNext:{
                    gears.accept($0)
                })
                 self?.apiManager.loadGearType().map{ $0 }.subscribe(onNext:{
                    gearTypes.accept($0)
                })
            }).disposed(by: disposeBag)
        
        let didSelectCell = input.didSelectCell.do(onNext: { [weak self] gearId in
            
        })
          
        return Output(gearObservable: gears, gearTypeObservable: gearTypes, didSelectCell: didSelectCell)
    }
    
}

