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
}

public protocol SignInOutput {
    var loginCheck: PublishRelay<Bool> { get }
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
    
    var loginButtonTouched: PublishRelay<Void> = PublishRelay<Void>()
    
    var loginCheck: PublishRelay<Bool> = PublishRelay<Bool>()
    let apiManager: APIManager = APIManager.shared
    
    
}
