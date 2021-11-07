//
//  File.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/27.
//

import Foundation
import UIKit

// 팔로워랑 팔로우 ViewModel 작성해야 함

class FollowerViewController: UIViewController {
    
    @IBOutlet weak var followerTableView: UITableView!
    @IBOutlet weak var follwerSearchBar: UISearchBar!
    
    
    
    let manager = APIManager.shared
    let userVM = UserViewModel.shared
    
    var searchInputText: String = ""
    var fetchingMore: Bool = false
    var page: Int = 0
    
    var searchData = [CellRepresentable]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followerTableView.keyboardDismissMode = .onDrag
        
        followerTableView.register(UINib(nibName:String(describing: SearchTableViewCell.self), bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        followerTableView.register(UINib(nibName:String(describing: EmptySearchResultCell.self), bundle: nil), forCellReuseIdentifier: "EmptySearchResultCell")
        followerTableView.register(UINib(nibName:String(describing: LoadingCell.self), bundle: nil), forCellReuseIdentifier: "LoadingCell")
        
    }
}



extension FollowerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userVM.followers.isEmpty && section != 1{
            return 1
        } else if section == 0 {
            return userVM.followers.count
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return searchData[indexPath.row].cellForRowAt(tableView, indexPath: indexPath)
    }
}
extension FollowerViewController: UITableViewDelegate{
    
}
