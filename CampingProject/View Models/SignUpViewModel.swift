//
//  SignUpViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/02/03.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
// TODO: do 활용 얼럿 창
    let disposeBag = DisposeBag()

    let checkEmail: AnyObserver<String>
    
    let hideLabel: Observable<Bool>
    let showNextPage: Observable<Bool>
    
    init(){
        let store = Store.shared
        
        let checking = PublishSubject<String>()
        let hidingLabel = PublishRelay<Bool>()
        
        checkEmail = checking.asObserver()
        hideLabel = hidingLabel.asObservable()
        
        checking
            .flatMap{ store.emailDuplicateCheckRx(email: $0) }
            .subscribe(onNext:{ result in
                hidingLabel.accept(!result)
            }).disposed(by: disposeBag)
        
        
        showNextPage = hidingLabel.asObservable()
    
    }
}
