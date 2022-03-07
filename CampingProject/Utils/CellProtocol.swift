//
//  CellProtocol.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/03.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewModel {
    associatedtype Input
    associatedtype Output

    func transform(input: Input, disposeBag: DisposeBag) -> Output
}

public protocol FollowInput {
    func loadFollow()
    var fetchMoreDatas: PublishRelay<Void> { get }
    var searchText: PublishRelay<String> { get }
}

public protocol FollowOutput {
    var follow: Observable<[Friend]> { get }
    var isLoadingSpinnerAvaliable: PublishRelay<Bool> { get }
}

public protocol FollowViewModelType {
    var inputs: FollowInput { get }
    var outputs: FollowOutput { get }
}
