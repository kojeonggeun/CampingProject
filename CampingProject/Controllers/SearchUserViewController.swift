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
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension SearchUserViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableView", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        
        cell.updateUI(email: "testEmail", name: "testName")
        
        return cell
    }
    
    
}

extension SearchUserViewController: UITableViewDelegate{
    
}

extension SearchUserViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInputText = searchText
        manager.searchUser(searchText: searchText)
        
    }
}
