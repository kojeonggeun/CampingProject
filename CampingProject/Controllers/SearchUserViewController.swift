//
//  SearchFriendViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/14.
//

import Foundation
import UIKit


//TODO: 스크롤을 끝까지 내려서 데이터 불러 올떄 데이터가 있으면 로딩 화면 띄우게 해야함 , 검색 결과가 없을 때 화면도 추가 해야 함
class SearchUserViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!

    
    let manager = APIManager.shared
    var searchInputText: String = ""
    var searchData: [SearchUser] = []
    
    var fetchingMore: Bool = false
    var page: Int = 0
    
    
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
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
            
            cell.sendFollowButton.tag = indexPath.row
            cell.sendFollowButton.addTarget(self, action: #selector(sendFollowRequest), for: .touchUpInside)
            
            
            let email = self.searchData[indexPath.row].email
            
            let name = self.searchData[indexPath.row].name
            var imageUrl = self.searchData[indexPath.row].userImageUrl

            if imageUrl == "" {
                imageUrl = "https://doodleipsum.com/500/avatar-3"
            }

            print(imageUrl)
            DispatchQueue.global().async {
                let url = URL(string: imageUrl)
                let data = try? Data(contentsOf: url!)
                print(url, data)
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
        
        let id = self.searchData[sender.tag].id
        let isPublic = self.searchData[sender.tag].isPublic
        
        manager.followRequst(id: id, isPublic: isPublic, completion: { data in
            if data {
                sender.backgroundColor = .white
                sender.setTitle("팔로워", for: .normal)
            } else {
                
            }
        })
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

                self.searchData.append(contentsOf: data)
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
            for i in data{
                self.searchData.append(i)
            }

            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        })
    }
}
