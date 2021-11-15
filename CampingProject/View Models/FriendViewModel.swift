//
//  FriendViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/06.
//

import Foundation
import UIKit

class FriendViewModel: FollowerRepresentable {
  
    var searchFriend: Friend
    var friendType: String
    
    let manager = APIManager.shared
    let userVM = UserViewModel.shared
    
    init(searchFriend: Friend, friendType: String) {
        self.searchFriend = searchFriend
        self.friendType = friendType
        
    }
    
    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
            
            cell.sendEventButton.tag = indexPath.row
            cell.sendEventButton.addTarget(self, action: #selector(deleteRequest), for: .touchUpInside)
       
            let email = self.searchFriend.email
            
            let name = self.searchFriend.name
//            var imageUrl = self.searchData.userImageUrl
//
//            if imageUrl == "" {
//                imageUrl = "https://doodleipsum.com/500/avatar-3"
//            }

//            DispatchQueue.global().async {
//                let url = URL(string: imageUrl)
//                let data = try? Data(contentsOf: url!)
//                
//                DispatchQueue.main.async {
//                    let image = UIImage(data: data!)
//                    cell.updateImage(image: image)
//                    }
//                }
            
            cell.updateUI(email: email, name: name)
            
            return cell
        } else  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCell else { return UITableViewCell() }
            
            cell.start()
            
            return cell
        }
    }
    
    @objc func deleteRequest(sender: UIButton){
        let id = self.searchFriend.friendId
        
        userVM.deleteFollower(id: id)
        
    }

}
