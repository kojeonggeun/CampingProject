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
    private var userId: Int
    private let _gearDetail = PublishSubject<GearDetail>()
    
    var deleteButtonTouched: PublishRelay<Void> = PublishRelay<Void>()

    public var showGearDetail: Observable<GearDetail> {
        return _gearDetail.asObserver()
    }

    init(gearId: Int, userId: Int) {

        self.gearId = gearId
        self.userId = userId

        deleteButtonTouched.subscribe({ _ in
            self.apiManager.deleteGear(gearId: self.gearId)
        }).disposed(by: disposeBag)

    }
    func loadGearDetail() {
        
        store.loadDetailUserGearRx(userId: self.userId, gearId: self.gearId)
            .subscribe(onNext: {
                self._gearDetail.onNext($0)
            }).disposed(by: disposeBag)

    }
    public var inputs: GearDetailInput { return self }
    public var outputs: GearDetailOutput { return self }

}
