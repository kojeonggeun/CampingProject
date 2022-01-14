//
//  SearchUserViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/14.
//

import Foundation
import RxSwift
import RxCocoa

class SearchUserDetailViewModel {
    
    static let shared = SearchUserDetailViewModel()
    let userVM = UserViewModel.shared
    let disposeBag = DisposeBag()
    
    private let searchGears = PublishRelay<[CellData]>()
    
    var searchGearObservable: Observable<[CellData]> {
        return searchGears.asObservable()
    }
    
    func loadSearchGear(id: Int){
        userVM.loadSearchUserGearRx(userId: id)
            .subscribe(onNext: { data in
                self.searchGears.accept(data)
            }).disposed(by: disposeBag)
    }
}
