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

    let viewModel = SearchResultViewModel()
 
    private lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(
                            x: 0,
                            y: 0,
                            width: view.frame.size.width,
                            height: 100)
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()
    
    
    
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let email = apiManager.userInfo?.user?.email
        self.navigationController?.navigationBar.topItem?.title = email
        
        searchTableView.keyboardDismissMode = .onDrag
        
    
        searchTableView.register(UINib(nibName:String(describing: SearchTableViewCell.self), bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        searchTableView.register(UINib(nibName:String(describing: EmptySearchResultCell.self), bundle: nil), forCellReuseIdentifier: "EmptySearchResultCell")
        

        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.inputs.searchText)
            .disposed(by: disposeBag)

//        TODO: 1. 무한 스크롤 구현해야하고 , 구조 다듬어야 함 -> 끝
//        TODO: 2. 검색 중일때 더미 셀 구성해야 함 -> 안하는걸로
//        TODO: 3. 기본 이미지 수정 -> 끝
//        TODO: 4. 테이블뷰 footer에 로딩셀 추가 -> 끝, 검색결과없을때 해야함
        
//        FIXME: Cell 생성 시 여러번 호출됨 왜이러지?!?!
        viewModel.outputs.searchUsers
            .asDriver(onErrorJustReturn: [])
            .drive(searchTableView.rx.items){ (tableView, row, element) in
                if element.id == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptySearchResultCell.identifier, for: IndexPath(row: row, section: 0)) as? EmptySearchResultCell
                    else{ return UITableViewCell()}
                    cell.updateLabel(text: element.name)
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier,for: IndexPath(row: row, section: 0)) as? SearchTableViewCell
                    else { return UITableViewCell()}
                    cell.onData.accept(element)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoadingSpinnerAvaliable.subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                  let self = self else { return }
            self.searchTableView.tableFooterView = isAvaliable ? self.viewSpinner : UIView(frame: .zero)
        }
        .disposed(by: disposeBag)
        
        
        searchTableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            
            let offsetY = self.searchTableView.contentOffset.y
            let contentSize = self.searchTableView.contentSize.height
            let boundsSizeHeight = self.searchTableView.bounds.size.height - 50
    
            if offsetY > (contentSize - boundsSizeHeight){
                self.viewModel.fetchMoreDatas.accept(())
            }
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
    }
    
}


extension SearchUserViewController: UITableViewDelegate{

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentSize = scrollView.contentSize.height
//        let boundsSizeHeight = scrollView.bounds.size.height
//
//        if offsetY > (contentSize - boundsSizeHeight){
//            if !fetchingMore{
//                beginBatchFetch()
//            }
//        }
//    }
////
//    func beginBatchFetch() {
//        fetchingMore = true
//
//        DispatchQueue.main.async {
//                self.searchTableView.reloadSections(IndexSet(integer: 0), with: .none)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//            self.page += 1
//            self.viewModel.inputs.page.accept(self.page)
//            self.apiManager.searchUser(searchText: self.searchInputText,page: self.page, completion: { data in
////                self.appendSearchData(data: data)
//                DispatchQueue.main.async {
//
//                    self.fetchingMore = false
//                    self.searchTableView.reloadData()
//                }
//            })
//        })
//    }
//
    
    
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



