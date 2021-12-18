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
    let userVM = UserViewModel.shared
    
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
    
    func moveFriendView(){
        print("클릭 한 사용자 ID \(searchData.id)")
        print("클릭 한 사용자 Email \(searchData.email)")
        print("클릭 한 사용자 Name \(searchData.name)")
            
        userVM.loadFriendInfo(friendId: searchData.id, completion: { data in
            print("사용자 상세 정보 \(self.userVM.friendInfo[0].user)")
            
        })
        
    }
}
