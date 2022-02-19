//
//  SearchFriendViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/14.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchUserViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!

    let apiManager = APIManager.shared
    let disposeBag = DisposeBag()
    
    var searchData: [CellRepresentable] = []
    var cellHeightsDictionary: NSMutableDictionary = [:]
    var store = Store.shared
    var searchInputText: String = ""
    var fetchingMore: Bool = false
    var hasNext: Bool = false
    var page: Int = 0
    let viewModel = SearchResultViewModel()
 
    
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let email = apiManager.userInfo?.user?.email
        self.navigationController?.navigationBar.topItem?.title = email
        
        searchTableView.keyboardDismissMode = .onDrag
        
    
        searchTableView.register(UINib(nibName:String(describing: SearchTableViewCell.self), bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
//        searchTableView.register(UINib(nibName:String(describing: EmptySearchResultCell.self), bundle: nil), forCellReuseIdentifier: "EmptySearchResultCell")
        searchTableView.register(UINib(nibName:String(describing: LoadingCell.self), bundle: nil), forCellReuseIdentifier: "LoadingCell")

        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.inputs.searchText)
            .disposed(by: disposeBag)

//        TODO: 1. 무한 스크롤 구현해야하고 , 구조 다듬어야 함 -> 하는 중
//        TODO: 2. 검색 중일때 더미 셀 구성해야 함
//        TODO: 3. 기본 이미지 수정
        
//        FIXME: Cell 생성 시 여러번 호출됨 왜이러지?!?!
        viewModel.outputs.searchUser
            .map { $0.users }
            .asDriver(onErrorJustReturn: [])
            .drive(searchTableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)){ (row, element, cell) in
                cell.onData.accept(element)    
            }
            .disposed(by: disposeBag)
        
//        searchTableView.rx.modelSelected(SearchUser.self)
//            .subscribe(onNext:{ user in
//                print(user)
//            }).disposed(by: disposeBag)
//        searchTableView.rx.itemSelected
//            .subscribe(onNext:{ index in
//                print(index)
//            }).disposed(by: disposeBag)
        
        searchTableView.rx.didScroll.subscribe { [weak self] _ in
                    guard let self = self else { return }
                    let offSetY = self.searchTableView.contentOffset.y
                    let contentHeight = self.searchTableView.contentSize.height

                    if offSetY > (contentHeight - self.searchTableView.frame.size.height - 100) {

//                        self.viewModel.fetchMoreDatas.onNext(())
                    }
                }
                .disposed(by: disposeBag)
        
    }
    
}


extension SearchUserViewController: UITableViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentSize = scrollView.contentSize.height
        let boundsSizeHeight = scrollView.bounds.size.height

        if offsetY > (contentSize - boundsSizeHeight){
            if !fetchingMore{
                beginBatchFetch()
            }
        }
    }
//
    func beginBatchFetch() {
        fetchingMore = true

        DispatchQueue.main.async {
                self.searchTableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.page += 1
            self.viewModel.inputs.page.accept(self.page)
            self.apiManager.searchUser(searchText: self.searchInputText,page: self.page, completion: { data in
//                self.appendSearchData(data: data)
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
}
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchInputText = searchText
//        self.searchData.removeAll()
//        self.page = 0
//
//        apiManager.searchUser(searchText: searchText, completion: { data in
////            self.appendSearchData(data: data)
//            DispatchQueue.main.async {
//                self.searchTableView.reloadData()
//            }
//        })
//    }
//
////    func appendSearchData(data: [SearchUser]){
////        for i in data{
////            self.searchData.append(SearchResultViewModel(searchData: SearchUser(id: i.id, name: i.name, email: i.email, phone: i.phone, userImageId: i.userImageId, userImageUrl: i.userImageUrl, isPublic: i.isPublic),searchInputText: self.searchInputText))
////        }
////    }
//}



