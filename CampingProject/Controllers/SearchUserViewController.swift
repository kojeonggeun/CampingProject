//
//  SearchFriendViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/14.
//

import Foundation
import UIKit


//TODO: 코드를 밖으로 분리해서 재사용 가능하게 만들어야 함, 팔로워 & 팔로잉 화면에도 사용 예정

class SearchUserViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!

    let manager = APIManager.shared
    
    var searchInputText: String = ""
    var fetchingMore: Bool = false
    var page: Int = 0
    var searchData: [CellRepresentable] = []
    
    @IBAction func sendFollowRequest(_ sender: Any) {
        
    }
    
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.register(UINib(nibName:String(describing: SearchTableViewCell.self), bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        searchTableView.register(UINib(nibName:String(describing: EmptySearchResultCell.self), bundle: nil), forCellReuseIdentifier: "EmptySearchResultCell")
        searchTableView.register(UINib(nibName:String(describing: LoadingCell.self), bundle: nil), forCellReuseIdentifier: "LoadingCell")
    }
}

extension SearchUserViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchData.isEmpty && section != 1{
            return 1
        } else if section == 0 {
            return self.searchData.count
        } else if section == 1 && fetchingMore{
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        if self.searchData.isEmpty && indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptySearchResultCell", for: indexPath) as? EmptySearchResultCell else { return UITableViewCell() }

            cell.updateLabel(text: searchInputText)
            return cell
            
        }
            
        return self.searchData[indexPath.row].cellForRowAt(tableView, indexPath: indexPath)
        
    }
}


extension SearchUserViewController: UITableViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = searchTableView.contentOffset.y
        let contentSize = searchTableView.contentSize.height
        let boundsSizeHeight = searchTableView.bounds.size.height
        
        
        if offsetY > (contentSize - boundsSizeHeight){
            if !fetchingMore{
                beginBatchFetch()
            }
            
        }
    }
    
    private func beginBatchFetch() {
        fetchingMore = true
        
        DispatchQueue.main.async {
                self.searchTableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.page += 1
            self.manager.searchUser(searchText: self.searchInputText,page: self.page, completion: { data in
                self.appendSearchData(data: data)
                
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
            self.appendSearchData(data: data)
            
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        })
    }
    
    func appendSearchData(data: [SearchUser]){
        for i in data{
            self.searchData.append(SearchResultViewModel(searchData: SearchUser(id: i.id, name: i.name, email: i.email, phone: i.phone, userImageId: i.userImageId, userImageUrl: i.userImageUrl, isPublic: i.isPublic),searchInputText: self.searchInputText))
        }
    }
}



