//
//  CellProtocol.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/03.
//


import UIKit
import RxSwift

protocol CellRepresentable {
    var searchData: SearchUser { get }
    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

protocol FollowRepresentable {
    var searchFriend: Friend { get }
    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}


protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input,disposeBag: DisposeBag) -> Output
}
