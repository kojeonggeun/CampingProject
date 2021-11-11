//
//  File.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/27.
//

import Foundation
import UIKit

// 검색 기능 구현 해야 함

class FollowerViewController: UIViewController {
    
    @IBOutlet weak var followerTableView: UITableView!
    @IBOutlet weak var follwerSearchBar: UISearchBar!
    
    
    
    let manager = APIManager.shared
    let userVM = UserViewModel.shared
    
    var searchInputText: String = ""
    var fetchingMore: Bool = false
    var page: Int = 0
    
    var followerData = [FollowerRepresentable]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Awd")
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

    //    친구가 없을 때 예외처리 해야함
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return followerData[indexPath.row].cellForRowAt(tableView, indexPath: indexPath)
    }
}

extension FollowerViewController: UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = followerTableView.contentOffset.y
        let contentSize = followerTableView.contentSize.height
        let boundsSizeHeight = followerTableView.bounds.size.height
        
        if offsetY > (contentSize - boundsSizeHeight){
            if !fetchingMore{
                beginBatchFetch()
            }
        }
    }
    
    private func beginBatchFetch() {
        fetchingMore = true
        
        DispatchQueue.main.async {
                self.followerTableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.page += 1
//            self.manager.searchUser(searchText: self.searchInputText,page: self.page, completion: { data in
//                self.appendSearchData(data: data)
                
                DispatchQueue.main.async {
                    self.fetchingMore = false
                    self.followerTableView.reloadData()
                }
            })
//        })
    }
}

extension FollowerViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInputText = searchText
        self.page = 0
    }
}

