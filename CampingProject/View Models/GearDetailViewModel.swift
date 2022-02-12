//
//  GearDetailViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/02/05.
//

import Foundation
import RxSwift
import RxCocoa

public protocol gearDetailInput {
    func loadGearDetail()
}

public protocol gearDetailOutput {
    var showGearDetail: Observable<GearDetail> { get }
}

public protocol gearDetailViewModelType {
    var inputs: gearDetailInput { get }
    var outputs: gearDetailOutput { get }
    
}
class GearDetailViewModel: gearDetailViewModelType, gearDetailInput, gearDetailOutput {
    private let apiManager = APIManager.shared
    private let disposeBag = DisposeBag()
    private let store = Store.shared
    
    private var gearId: Int
    private let gearDetail = PublishSubject<GearDetail>()
    
    public var showGearDetail: Observable<GearDetail> {
        return gearDetail.asObserver()
    }

    init(gearId: Int){
        self.gearId = gearId
        
    }
    func loadGearDetail(){
        let userId: Int = apiManager.userInfo!.user!.id
        
        store.loadDetailUserGearRx(userId: userId, gearId: self.gearId)
            .subscribe(onNext: {self.gearDetail.onNext($0)})
            .disposed(by: disposeBag)
    }
    
    public var inputs: gearDetailInput { return self }
    public var outputs: gearDetailOutput { return self }
    
}
