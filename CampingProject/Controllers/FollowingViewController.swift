//
//  FollowingViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/07.
//

import Foundation
import UIKit

class FollowingViewController: UIViewController {
    @IBOutlet weak var followingTableView: UITableView!
    @IBOutlet weak var followingSearchBar: UISearchBar!
    
    let manager = APIManager.shared
    let userVM = UserViewModel.shared
    
    var searchData: [CellRepresentable] = []
    var fetchingMore: Bool = false
    var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(searchData)
        
        followingTableView.keyboardDismissMode = .onDrag
        followingTableView.register(UINib(nibName:String(describing: SearchTableViewCell.self), bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        followingTableView.register(UINib(nibName:String(describing: EmptySearchResultCell.self), bundle: nil), forCellReuseIdentifier: "EmptySearchResultCell")
        followingTableView.register(UINib(nibName:String(describing: LoadingCell.self), bundle: nil), forCellReuseIdentifier: "LoadingCell")
    }
}


extension FollowingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userVM.followings.isEmpty && section != 1{
            return 1
        } else if section == 0 {
            return userVM.followings.count
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return searchData[indexPath.row].cellForRowAt(tableView, indexPath: indexPath)
    }
}
extension FollowingViewController: UITableViewDelegate{
}

