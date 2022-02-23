//
//  GearDetailViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/02/05.
//

import Foundation
import RxSwift
import RxCocoa

public protocol GearDetailInput {
    func loadGearDetail()
    var deleteButtonTouched: PublishRelay<Void> { get }
}

public protocol GearDetailOutput {
    var showGearDetail: Observable<GearDetail> { get }
}

public protocol GearDetailViewModelType {
    var inputs: GearDetailInput { get }
    var outputs: GearDetailOutput { get }
    
}
class GearDetailViewModel: GearDetailViewModelType, GearDetailInput, GearDetailOutput {
    private let apiManager = APIManager.shared
    private let disposeBag = DisposeBag()
    private let store = Store.shared
    
    private var gearId: Int
    private let gearDetail = PublishSubject<GearDetail>()
    var deleteButtonTouched: PublishRelay<Void> = PublishRelay<Void>()
    
    public var showGearDetail: Observable<GearDetail> {
        return gearDetail.asObserver()
    }
  
    init(gearId: Int){
        
        self.gearId = gearId
        
        deleteButtonTouched.subscribe({ _ in
            self.apiManager.deleteGear(gearId: self.gearId)
        })
        .disposed(by: disposeBag)
        
    }
    func loadGearDetail(){
        let userId: Int = apiManager.userInfo!.user!.id
        
        print(userId, self.gearId)
        store.loadDetailUserGearRx(userId: userId, gearId: self.gearId)
            .subscribe(onNext: {
                self.gearDetail.onNext($0)
            }).disposed(by: disposeBag)
        
    }
    
    public var inputs: GearDetailInput { return self }
    public var outputs: GearDetailOutput { return self }
    
}
