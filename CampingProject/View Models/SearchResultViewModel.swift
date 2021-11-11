//
//  SearchResultViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/03.
//

import Foundation
import UIKit

class SearchResultViewModel: CellRepresentable {
    
    var searchData: SearchUser
    var searchInputText: String
    
    let manager = APIManager.shared
    
    init(searchData: SearchUser, searchInputText: String) {
        self.searchData = searchData
        self.searchInputText = searchInputText
        
    }
    
    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
     
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
            
            cell.sendEventButton.tag = indexPath.row
            cell.sendEventButton.addTarget(self, action: #selector(sendFollowRequest), for: .touchUpInside)
       
            let email = self.searchData.email
            
            let name = self.searchData.name
            var imageUrl = self.searchData.userImageUrl

            if imageUrl == "" {
                imageUrl = "https://doodleipsum.com/500/avatar-3"
            }

            DispatchQueue.global().async {
                let url = URL(string: imageUrl)
                let data = try? Data(contentsOf: url!)
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    cell.updateImage(image: image)
                    }
                }
            
            cell.updateUI(email: email, name: name)
            
            return cell
        } else  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCell else { return UITableViewCell() }
            
            cell.start()
            
            return cell
        }
    }
    
    @objc func sendFollowRequest(sender: UIButton){
        let id = self.searchData.id
        let isPublic = self.searchData.isPublic
        
        manager.followRequst(id: id, isPublic: isPublic, completion: { data in
            if data {
                sender.backgroundColor = .white
                sender.setTitle("팔로워", for: .normal)
            } else {
                
            }
        })
    }
}
