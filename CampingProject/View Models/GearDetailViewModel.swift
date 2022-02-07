//
//  GearDetailViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/02/05.
//

import Foundation
import RxSwift
import RxCocoa

class GearDetailViewModel: ViewModel {
    struct Input {
        let gearId: Observable<Int>
        
    }
    struct Output {
        let showGearDetail: Observable<GearDetail>
    }
    let apiManager = APIManager.shared
 
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let userId: Int = apiManager.userInfo!.user!.id
        let fetchData = PublishSubject<GearDetail>()
        
        input.gearId.subscribe(onNext: {
            Store.shared.loadDetailUserGearRx(userId: userId, gearId: $0)
                .subscribe(onNext: {fetchData.onNext($0)})
        }).disposed(by: disposeBag)
        
        
        return Output(showGearDetail: fetchData.asObserver())
        
    }
}
