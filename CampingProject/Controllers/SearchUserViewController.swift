//
//  SearchFriendViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/14.
//

import Foundation
import UIKit
import RxSwift

class SearchUserViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!

    let apiManager = APIManager.shared
    let disposeBag = DisposeBag()
    
    var searchData: [CellRepresentable] = []
    var cellHeightsDictionary: NSMutableDictionary = [:]
    var userVM = UserViewModel.shared
    var searchInputText: String = ""
    var fetchingMore: Bool = false
    var hasNext: Bool = false
    var page: Int = 0

 
    
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let email = apiManager.userInfo?.user?.email
        self.navigationController?.navigationBar.topItem?.title = email
        

        searchTableView.keyboardDismissMode = .onDrag
        
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
        
        return self.searchData[indexPath.row].cellForRowAt(tableView, indexPath: indexPath)
        
    }
}

extension SearchUserViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        TODO: 친구의 id값 활용 친구장비 넘겨줘야함
        if !self.searchData.isEmpty{
            let id = self.searchData[indexPath.row].searchData.id
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "FriendInfo")as! FriendInfoViewController

//            두개의 Observable 합쳐서 내려보내준다
            Observable.combineLatest(
                self.userVM.loadFriendInfoRx(id: id),
                self.userVM.loadUserGearRx())
                .subscribe(onNext: { userInfo , userSearch in
                    pushVC.userInfo = userInfo
                    for i in userSearch {
//                        pushVC.userSerachGear.append(MyGearViewModel(myGear:CellData(id: i.id, name: i.name, gearTypeId: i.gearTypeId, gearTypeName: i.gearTypeName, color: i.color, company: i.company, capacity: i.capacity, price: i.price, buyDt: i.buyDt)))
                    }
                    self.navigationController?.pushViewController(pushVC, animated: true)
                }, onError: { err in
                    print(err.localizedDescription)
                }).disposed(by: disposeBag)
                
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.searchData.isEmpty{
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentSize = scrollView.contentSize.height
        let boundsSizeHeight = scrollView.bounds.size.height
        
        if offsetY > (contentSize - boundsSizeHeight){
            if !fetchingMore{
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
       
        DispatchQueue.main.async {
                self.searchTableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.page += 1
            self.apiManager.searchUser(searchText: self.searchInputText,page: self.page, completion: { data in
                self.appendSearchData(data: data)

                DispatchQueue.main.async {
                    self.fetchingMore = false
                    self.searchTableView.reloadData()
                }
            })
        })
    }
    

//    셀의 높이를 저장
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightsDictionary.setObject(cell.frame.size.height, forKey: indexPath as NSCopying)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = cellHeightsDictionary.object(forKey: indexPath) as? Double {
            
            return CGFloat(height)
        }
        return UITableView.automaticDimension
    }
    
}

extension SearchUserViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInputText = searchText
        self.searchData.removeAll()
        self.page = 0
   
        apiManager.searchUser(searchText: searchText, completion: { data in
            self.appendSearchData(data: data)
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        })
    }
    
    func appendSearchData(data: [SearchUser]){
        for i in data{
            self.searchData.append(SearchResultViewModel(searchData: SearchUser(id: i.id, name: i.name, email: i.email, phone: i.phone, userImageId: i.userImageId, userImageUrl: i.userImageUrl, isPublic: i.isPublic),searchInputText: self.searchInputText))
        }
    }
}



