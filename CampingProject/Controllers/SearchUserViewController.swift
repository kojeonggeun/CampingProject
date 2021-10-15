//
//  SearchFriendViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/14.
//

import Foundation
import UIKit


class SearchUserViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var manager = APIManager.shared
    var searchInputText: String = ""
    var searchData: [SearchUser] = []
    var fetchingMore: Bool = false
    var page: Int = 0
    
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
        
        for i in self.searchData{
            cell.updateUI(email: i.email, name: i.name)
        }
        
        
        
        return cell
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
//                self.searchData = data
                
                self.searchData.append(contentsOf: data)
                print(self.searchData)
                self.searchTableView.reloadData()
            })
            self.fetchingMore = false
        })
    }
 
}



extension SearchUserViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInputText = searchText
       
        manager.searchUser(searchText: searchText, completion: { data in
            self.searchData = data
//            self.searchData.append(contentsOf: data)
            print(self.searchData)
            self.searchTableView.reloadData()
        })
    }
    
    
    
    
}
