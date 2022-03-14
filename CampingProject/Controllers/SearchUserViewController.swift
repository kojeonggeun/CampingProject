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
//  FIXME: 친구가 아닌 친구검색
// FIXME: 친구에서 상세보기 구현해야함
class SearchUserViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!

    let apiManager = APIManager.shared
    let disposeBag = DisposeBag()
    let store = Store.shared
    let viewModel = SearchResultViewModel()

    var cellHeightsDictionary: NSMutableDictionary = [:]

    var searchInputText: String = ""

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

// MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        setBind()
    }

    func setView() {
        let email = apiManager.userInfo?.user?.email
        self.navigationController?.navigationBar.topItem?.title = email

        searchTableView.keyboardDismissMode = .onDrag

        searchTableView.register(UINib(nibName: String(describing: SearchTableViewCell.self), bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        searchTableView.register(UINib(nibName: String(describing: EmptySearchResultCell.self), bundle: nil), forCellReuseIdentifier: "EmptySearchResultCell")

    }
    func setBind() {
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.inputs.searchText)
            .disposed(by: disposeBag)

        viewModel.outputs.searchUsers
            .asDriver(onErrorJustReturn: [])
            .drive(searchTableView.rx.items) { (tableView, row, element) in
                if element.id == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptySearchResultCell.identifier, for: IndexPath(row: row, section: 0)) as? EmptySearchResultCell
                    else { return UITableViewCell()}
                    self.searchTableView.allowsSelection = false
                    cell.updateLabel(text: element.name)
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as? SearchTableViewCell
                    else { return UITableViewCell()}
                    self.searchTableView.allowsSelection = true
                    cell.onData.accept(element)
                    return cell
                }
            }
            .disposed(by: disposeBag)

        viewModel.outputs.isLoadingSpinnerAvaliable
            .subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                  let self = self else { return }
            self.searchTableView.tableFooterView = isAvaliable ? self.viewSpinner : UIView(frame: .zero)
        }
        .disposed(by: disposeBag)

        searchTableView.rx.didScroll
            .subscribe { [weak self] _ in
            guard let self = self else { return }

            let offsetY = self.searchTableView.contentOffset.y
            let contentSize = self.searchTableView.contentSize.height
            let boundsSizeHeight = self.searchTableView.bounds.size.height - 50

            if offsetY > (contentSize - boundsSizeHeight) {
                self.viewModel.fetchMoreDatas.accept(())
            }
        }
        .disposed(by: disposeBag)

        searchTableView.rx.modelSelected(SearchUser.self)
            .subscribe(onNext: { user in
                guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: SearchUserDetailViewController.identifier) as?  SearchUserDetailViewController else {return}
                pushVC.userId = user.id
                self.navigationController?.pushViewController(pushVC, animated: true)
            }).disposed(by: disposeBag)

    }
}

extension SearchUserViewController: UITableViewDelegate {

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
