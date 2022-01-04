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
    
    
    let userVM = UserViewModel.shared
    let apiManager = APIManager.shared
    var searchInputText: String = ""
    var fetchingMore: Bool = false
    var page: Int = 0
    var id: Int = 0
    
    var followerData = [FollowRepresentable]()
    var followerSearchData = [FollowRepresentable]()

//    MARK: LifeCycles
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
      
        if self.followerData.isEmpty && section != 1{
            return 1
            
        } else if section == 0 {
            
            if !self.followerSearchData.isEmpty{
                return self.followerSearchData.count
            }
            if !searchInputText.isEmpty && followerSearchData.isEmpty{
                return 1
            }
            return self.followerData.count
            
        } else if section == 1 && fetchingMore {
            return 1
        }
        
        return 0
    }

    //    친구가 없을 때 예외처리 해야함
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !searchInputText.isEmpty && followerSearchData.isEmpty || followerData.isEmpty{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptySearchResultCell", for: indexPath) as? EmptySearchResultCell else { return UITableViewCell() }
            cell.updateLabel(text: searchInputText)
            return cell
        }
        if !followerSearchData.isEmpty{
            return followerSearchData[indexPath.row].cellForRowAt(tableView, indexPath: indexPath)
        }else {
            return followerData[indexPath.row].cellForRowAt(tableView, indexPath: indexPath)
        }
    }
}

extension FollowerViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if followerSearchData.isEmpty {
            id = followerData[indexPath.row].searchFriend.friendId
        } else {
            id = followerSearchData[indexPath.row].searchFriend.friendId
        }
        
        self.userVM.loadFriendInfoRx(id: id )
            .subscribe(onNext : { result in
                print(result)
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "FriendInfo")as! FriendInfoViewController
                pushVC.friendInfo = result
                self.navigationController?.pushViewController(pushVC, animated: true)
            })
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y
        let contentSize = scrollView.contentSize.height
        let boundsSizeHeight = scrollView.bounds.size.height

        if offsetY > (contentSize - boundsSizeHeight){
            if !fetchingMore{
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
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
        self.followerSearchData.removeAll()
        self.page = 0

//        추후 팔로워 & 팔로잉 검색 기능 추가 예정
//        그때 수정
        for i in apiManager.followers{
            let first = i.email.split(separator: "@")[0]
            if first.lowercased().contains(searchText.lowercased()) {
                self.followerSearchData.append(FriendViewModel(searchFriend: Friend(id: i.id, friendId: i.friendId, name: i.name, profileUrl: i.profileUrl, email: i.email, status: i.status), friendType: "follower"))
            }
        }
        DispatchQueue.main.async {
            self.followerTableView.reloadData()
        }
    }
}

