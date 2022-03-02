//
//  FollowingViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/07.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

// TODO: 팔로잉했을때 프로필창에서 숫자 변화안됨

class FollowingViewController: UIViewController {
    @IBOutlet weak var followingTableView: UITableView!
    @IBOutlet weak var followingSearchBar: UISearchBar!
    
    let apiManager = APIManager.shared
    let store = Store.shared
    let disposeBag = DisposeBag()
    let viewModel = FollowingViewModel()
    
    var cellHeightsDictionary: NSMutableDictionary = [:]
  
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
        setBind()
        setView()
        
    }
    
    func setView(){
        followingTableView.keyboardDismissMode = .onDrag
        
        followingTableView.register(UINib(nibName:String(describing: SearchTableViewCell.self), bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        followingTableView.register(UINib(nibName:String(describing: EmptySearchResultCell.self), bundle: nil), forCellReuseIdentifier: "EmptySearchResultCell")
        
        viewModel.inputs.loadFollowings()
        
    }
    func setBind(){
        viewModel.outputs.followings
            .asDriver(onErrorJustReturn: [])
            .drive(followingTableView.rx.items){ (tableView, row, element) in
                if element.id == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptySearchResultCell.identifier, for: IndexPath(row: row, section: 0)) as? EmptySearchResultCell
                    else{ return UITableViewCell()}
                    self.followingTableView.allowsSelection = false
                    cell.updateLabel(text: element.name)
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier,for: IndexPath(row: row, section: 0)) as? SearchTableViewCell
                    else { return UITableViewCell()}
                    self.followingTableView.allowsSelection = true
                    cell.onFriend.accept(element)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        followingSearchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.inputs.searchText)
            .disposed(by: disposeBag)
        
        followingTableView.rx.didScroll
            .subscribe { [weak self] _ in
            guard let self = self else { return }

            let offsetY = self.followingTableView.contentOffset.y
            let contentSize = self.followingTableView.contentSize.height
            let boundsSizeHeight = self.followingTableView.bounds.size.height - 50
    
            if offsetY > (contentSize - boundsSizeHeight){
                self.viewModel.fetchMoreDatas.accept(())
            }
        }
        .disposed(by: disposeBag)
        
        viewModel.outputs.isLoadingSpinnerAvaliable
            .subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                  let self = self else { return }
            self.followingTableView.tableFooterView = isAvaliable ? self.viewSpinner : UIView(frame: .zero)
        }
        .disposed(by: disposeBag)
        
        followingTableView.rx.modelSelected(Friend.self)
            .subscribe(onNext:{ friend in
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: SearchUserDetailViewController.identifier) as! SearchUserDetailViewController
                pushVC.userId = friend.friendId
                self.navigationController?.pushViewController(pushVC, animated: true)
            }).disposed(by: disposeBag)
    }
}
extension FollowingViewController: UITableViewDelegate{
        
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

