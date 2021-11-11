//
//  CellProtocol.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/03.
//

import Foundation
import UIKit

protocol CellRepresentable {
    
    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}
protocol FollowerRepresentable {
    var searchFriend: Friend { get }
    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}
