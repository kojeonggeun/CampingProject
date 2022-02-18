//
//  SearchResultViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/03.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

public protocol SearchResultInput{
    var searchText: PublishRelay<String> { get }
}
public protocol SearchResultOutput{
    var searchUser: PublishRelay<[SearchUser]> { get }
}

public protocol SearchResultViewModelType {
    var inputs: SearchResultInput { get }
    var outputs: SearchResultOutput { get }
    
}

class SearchResultViewModel: SearchResultViewModelType,SearchResultInput,SearchResultOutput  {
    let apiManager = APIManager.shared
    let store = Store.shared
    let userGearVM = UserGearViewModel.shared
    let disposeBag = DisposeBag()
    var inputs: SearchResultInput { return self }
    var outputs: SearchResultOutput { return self }
    
    var searchText: PublishRelay<String> = PublishRelay<String>()
    var searchUser: PublishRelay<[SearchUser]> = PublishRelay<[SearchUser]>()
  
    init(){
        searchText.subscribe(onNext:{ text in
            self.apiManager.searchUser(searchText: text, completion: {result in
                self.searchUser.accept(result)
            })
        }).disposed(by: disposeBag)
    }
    
    
//    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
//
//            let email = self.searchData.email
//
//            let name = self.searchData.name
//            var imageUrl = self.searchData.userImageUrl
//
//            if imageUrl == "" {
//                imageUrl = "https://doodleipsum.com/500/avatar-3"
//            }
//
//            DispatchQueue.global().async {
//                let url = URL(string: imageUrl)
//                let data = try? Data(contentsOf: url!)
//
//                DispatchQueue.main.async {
//                    let image = UIImage(data: data!)
//                    cell.updateImage(image: image)
//                    }
//                }
//            cell.updateUI(email: email, name: name)
//            return cell
//        } else  {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCell else { return UITableViewCell() }
//            cell.start()
//            return cell
//        }
//    }
}
