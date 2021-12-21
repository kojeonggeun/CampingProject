//
//  SearchResultViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/03.
//

import Foundation
import UIKit

class SearchResultViewModel: CellRepresentable {
    
    let searchData: SearchUser
    let searchInputText: String
    
    
    let manager = APIManager.shared
    let userVM = UserViewModel.shared
    let userGearVM = UserGearViewModel.shared
    
    init(searchData: SearchUser, searchInputText: String) {
        self.searchData = searchData
        self.searchInputText = searchInputText
        
    }
    
    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
     
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
            

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
    
    func moveFriendView(comple: @escaping ((UserInfo) -> Void)){
       
        self.userVM.loadFriendInfo(friendId: self.searchData.id, completion: { data in
            if data {
                comple(self.userVM.friendInfo[0])
            }
        })
        
    }
}
