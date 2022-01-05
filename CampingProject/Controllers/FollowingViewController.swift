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
    let userVM = UserViewModel.shared
    let disposeBag = DisposeBag()
    
    var searchInputText: String = ""
    var fetchingMore: Bool = false
    var page: Int = 0
    var id: Int = 0
    
    var followingData: [FollowRepresentable] = []
    var followingSearchData = [FollowRepresentable]()
    
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        if self.followingData.isEmpty && section != 1{
            return 1
        } else if section == 0 {
            
            if !self.followingSearchData.isEmpty{
                return self.followingSearchData.count
            }
            if !searchInputText.isEmpty && followingSearchData.isEmpty{
                return 1
            }
            return self.followingData.count
            
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }

//    친구가 없을 때 예외처리 해야함
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if !searchInputText.isEmpty && followingSearchData.isEmpty || followingData.isEmpty{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptySearchResultCell", for: indexPath) as? EmptySearchResultCell else { return UITableViewCell() }
            cell.updateLabel(text: searchInputText)
            return cell
        }
        if !followingSearchData.isEmpty{
            return followingSearchData[indexPath.row].cellForRowAt(tableView, indexPath: indexPath)
        }else {
            return followingData[indexPath.row].cellForRowAt(tableView, indexPath: indexPath)
        }
    }
}
extension FollowingViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if followingSearchData.isEmpty {
            id = followingData[indexPath.row].searchFriend.friendId
        } else {
            id = followingSearchData[indexPath.row].searchFriend.friendId
        }
        
        self.userVM.loadFriendInfoRx(id: id )
            .subscribe(onNext : { result in
                print(result)
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "FriendInfo")as! FriendInfoViewController
                pushVC.userInfo = result
                self.navigationController?.pushViewController(pushVC, animated: true)
            }, onCompleted: {}
            ).disposed(by: disposeBag)

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
        searchInputText = searchText
        self.followingSearchData.removeAll()
        self.page = 0
        
    //        추후 팔로워 & 팔로잉 검색 기능 추가 예정
    //        그때 수정
        for i in apiManager.followings{
            let first = i.email.split(separator: "@")[0]
            if first.lowercased().contains(searchText.lowercased()) {
                self.followingSearchData.append(FriendViewModel(searchFriend: Friend(id: i.id, friendId: i.friendId, name: i.name, profileUrl: i.profileUrl, email: i.email, status: i.status), friendType: "follower"))
            }
        }
        DispatchQueue.main.async {
            self.followingTableView.reloadData()
        }
    }
}
