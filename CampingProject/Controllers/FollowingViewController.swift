//
//  FollowingViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/07.
//

import Foundation
import UIKit
import RxSwift

class FollowingViewController: UIViewController {
    @IBOutlet weak var followingTableView: UITableView!
    @IBOutlet weak var followingSearchBar: UISearchBar!
    
    let apiManager = APIManager.shared
    let store = Store.shared
    let disposeBag = DisposeBag()

    
  
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        followingTableView.keyboardDismissMode = .onDrag
        followingTableView.register(UINib(nibName:String(describing: SearchTableViewCell.self), bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        followingTableView.register(UINib(nibName:String(describing: EmptySearchResultCell.self), bundle: nil), forCellReuseIdentifier: "EmptySearchResultCell")
        followingTableView.register(UINib(nibName:String(describing: LoadingCell.self), bundle: nil), forCellReuseIdentifier: "LoadingCell")
    }
}

