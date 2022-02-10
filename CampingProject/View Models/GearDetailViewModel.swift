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
        let loadGearDetail: PublishSubject<Void> = PublishSubject<Void>()
    }
    
    struct Output {
        let showGearDetail: Observable<GearDetail>
    }
    
    let apiManager = APIManager.shared

    private var gearId:Int
    
    init(gearId: Int){
        self.gearId = gearId
    }
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        let userId: Int = apiManager.userInfo!.user!.id
        let fetchData = PublishSubject<GearDetail>()
        
        input.loadGearDetail.subscribe(onNext: {
            Store.shared.loadDetailUserGearRx(userId: userId, gearId: self.gearId)
                .subscribe(onNext: {fetchData.onNext($0)})
        }).disposed(by: disposeBag)
        
        return Output(showGearDetail: fetchData.asObserver())
        
    }
}
