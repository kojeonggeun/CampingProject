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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        
        cell.updateUI(email: "awd", name: "zxcv")
        return cell
    }
    
    
}
extension FollowerViewController: UITableViewDelegate{
    
}
