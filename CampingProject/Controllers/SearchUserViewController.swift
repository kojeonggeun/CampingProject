//
//  SearchFriendViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/14.
//

import Foundation
import UIKit


//TODO: 스크롤을 끝까지 내려서 데이터 불러 올떄 데이터가 있으면 로딩 화면 띄우게 해야함 , 검색 결과가 없을 때 화면도 추가 해야 함
class SearchUserViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    let manager = APIManager.shared
    var searchInputText: String = ""
    var searchData: [SearchUser] = []
    
    var fetchingMore: Bool = false
    var page: Int = 0
    
    
    @IBAction func sendFollowRequest(_ sender: Any) {
        
    }
    
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension SearchUserViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableView", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.sendFollowButton.tag = indexPath.row
        
        cell.sendFollowButton.addTarget(self, action: #selector(sendFollowRequest), for: .touchUpInside)
        
        cell.updateUI(email: self.searchData[indexPath.row].email, name: self.searchData[indexPath.row].name)
        
        return cell
    }
    @objc func sendFollowRequest(sender: UIButton){
        
        let id = self.searchData[sender.tag].id
        let isPublic = self.searchData[sender.tag].isPublic
        
        manager.followRequst(id: id, isPublic: isPublic, completion: { data in
            sender.backgroundColor = .white
            
            sender.setTitle("팔로워", for: .normal)
        })
        
    }
}


extension SearchUserViewController: UITableViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchTableView.contentOffset.y > (searchTableView.contentSize.height - searchTableView.bounds.size.height){
            if !fetchingMore{
                beginBatchFetch()
            }
            
        }
    }
    
    private func beginBatchFetch() {
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            self.page += 1
            self.manager.searchUser(searchText: self.searchInputText,page: self.page, completion: { data in

                self.searchData.append(contentsOf: data)
                DispatchQueue.main.async {
                    self.fetchingMore = false
                    self.searchTableView.reloadData()
                }
            })
        })
    }
}

extension SearchUserViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInputText = searchText
        
        self.searchData.removeAll()
        self.page = 0
    
        manager.searchUser(searchText: searchText, completion: { data in
            for i in data{
                self.searchData.append(i)
            }
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        })
    }
}
