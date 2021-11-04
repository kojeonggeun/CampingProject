//
//  File.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/27.
//

import Foundation
import UIKit

class FollowerViewController: UIViewController {
    
    @IBOutlet weak var followerTableView: UITableView!
    
    let manager = APIManager.shared
    let userVM = UserViewModel.shared
    
    var searchInputText: String = ""
    
    
    var fetchingMore: Bool = false
    var page: Int = 0
    
    var searchData: [CellRepresentable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        followerTableView.register(UINib(nibName:String(describing: SearchTableViewCell.self), bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        followerTableView.register(UINib(nibName:String(describing: EmptySearchResultCell.self), bundle: nil), forCellReuseIdentifier: "EmptySearchResultCell")
        followerTableView.register(UINib(nibName:String(describing: LoadingCell.self), bundle: nil), forCellReuseIdentifier: "LoadingCell")
     
    }
}

extension FollowerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userVM.friendData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        var email = userVM.friendData[indexPath.row].email
        var name = userVM.friendData[indexPath.row].name
        
        cell.updateUI(email: email, name: name)
        return cell
    }
    
    
}
extension FollowerViewController: UITableViewDelegate{
    
}
