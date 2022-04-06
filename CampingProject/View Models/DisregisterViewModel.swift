//
//  DisregisterViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/03/09.
//

import Foundation
import RxSwift
import RxRelay

public protocol DisregisterInput {
    var passwordText: PublishRelay<String> { get }
    var deleteUser: PublishRelay<Void> { get }
}

public protocol DisregisterOutput {
    var result: Observable<Bool> { get }
}

public protocol DisregisterViewModelType {
    var inputs: DisregisterInput { get }
    var outputs: DisregisterOutput { get }
}

class DisregisterViewModel: DisregisterInput, DisregisterOutput, DisregisterViewModelType{
    
    var inputs: DisregisterInput { return self }
    var outputs: DisregisterOutput { return self }
    
    var passwordText: PublishRelay<String> = PublishRelay<String>()
    var deleteUser: PublishRelay<Void> = PublishRelay<Void>()
    
    var _result: PublishRelay<Bool> = PublishRelay<Bool>()
    
    var result: Observable<Bool> { return self._result.asObservable()}
    
    let disposeBag = DisposeBag()
    init(){
        let store = Store.shared
        
        passwordText
            .flatMap{ store.passwordCertificationRx(password: $0)}
            .subscribe(onNext:{ [weak self ] result in
                self?._result.accept(result)
            }).disposed(by: disposeBag)
        
        deleteUser.subscribe({ _ in
            APIManager().disregister()
        })
    }
}
