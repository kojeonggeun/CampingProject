//
//  SignInViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/02/14.
//

import Foundation
import RxSwift
import RxCocoa

public protocol SignInlInput {
    var emailValueChanged: PublishRelay<String> { get }
    var pwValueChanged: PublishRelay<String> { get }
    var loginButtonTouched: PublishRelay<Void> { get }
    var autoLoginStatusChanged: PublishRelay<Bool> { get }
}

public protocol SignInOutput {
    var loginResult: PublishSubject<Bool> { get }
    var autoLogin: Observable<Bool> { get }
    var emailVaild: Observable<Bool> { get }
    var passwordVaild: Observable<Bool> { get }
}

public protocol SignInViewModelType {
    var inputs: SignInlInput { get }
    var outputs: SignInOutput { get }
    
}

class SignInViewModel: SignInViewModelType, SignInlInput, SignInOutput{
    var inputs: SignInlInput { return self }
    var outputs: SignInOutput { return self }
    
    var emailValueChanged: PublishRelay<String> = PublishRelay<String>()
    var pwValueChanged: PublishRelay<String> = PublishRelay<String>()
    
    var autoLoginStatusChanged: PublishRelay<Bool> = PublishRelay<Bool>()
    var autoLogin: Observable<Bool>

    var emailVaild: Observable<Bool>
    var passwordVaild: Observable<Bool>
    
    var loginButtonTouched: PublishRelay<Void> = PublishRelay<Void>()
    var loginResult: PublishSubject<Bool> = PublishSubject<Bool>()
    

    let disposeBag = DisposeBag()
    
    init(){
        let store = Store.shared
        let apiManager = APIManager.shared
        
        let email = emailValueChanged.asObservable()
        let password = pwValueChanged.asObservable()
        let combindLoginInfo = Observable.combineLatest(email, password){ ($0,$1) }
        
        autoLogin = autoLoginStatusChanged.asObservable()
        
        emailVaild = email.map{ apiManager.isValidEmail(email: $0)}
        passwordVaild = password.skip(1).map{ apiManager.isValidPassword(password: $0)}
        
        loginButtonTouched.withLatestFrom(combindLoginInfo)
            .subscribe(onNext: { [weak self] info in
                store.loginRx(email: info.0, password: info.1)
                    .subscribe(onNext:{ result in
                        UserViewModel()
                        self?.loginResult.onNext(result)
                    }).disposed(by: self!.disposeBag)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(autoLogin, loginResult) { $0 && $1 }
            .subscribe(onNext: { result in
                DB.userDefaults.set(result, forKey: "Auto")
            })
            .disposed(by: disposeBag)
        
       
    }
}
