//
//  SignUpViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/02/03.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModel {


    struct Input {
        let checkEmail: Observable<String>
    }

    struct Output {
        let hideLabel: Observable<Bool>
        let showNextPage: Observable<Bool>
    }

    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let store = Store.shared
        let hidingLabel = PublishRelay<Bool>()

        input.checkEmail
            .flatMap { store.emailDuplicateCheckRx(email: $0) }
            .subscribe(onNext: { result in
                hidingLabel.accept(!result)
            }).disposed(by: disposeBag)

        return Output.init(hideLabel: hidingLabel.asObservable(), showNextPage: hidingLabel.asObservable())
    }
}
