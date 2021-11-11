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
    
    var followingData: [FollowerRepresentable] = []
    var fetchingMore: Bool = false
    var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(followingData)
        
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

//    친구가 없을 때 예외처리 해야함
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return followingData[indexPath.row].cellForRowAt(tableView, indexPath: indexPath)
    }
}
extension FollowingViewController: UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = followingTableView.contentOffset.y
        let contentSize = followingTableView.contentSize.height
        let boundsSizeHeight = followingTableView.bounds.size.height
        
        if offsetY > (contentSize - boundsSizeHeight){
            if !fetchingMore{
                beginBatchFetch()
            }
        }
    }
    
    private func beginBatchFetch() {
        fetchingMore = true
        
        DispatchQueue.main.async {
                self.followingTableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.page += 1
//            self.manager.searchUser(searchText: self.searchInputText,page: self.page, completion: { data in
//                self.appendSearchData(data: data)
                
                DispatchQueue.main.async {
                    self.fetchingMore = false
                    self.followingTableView.reloadData()
                }
            })
//        })
    }
}


extension FollowingViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
   
    }
}
