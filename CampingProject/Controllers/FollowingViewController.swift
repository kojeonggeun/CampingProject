//
//  FollowingViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/07.
//

import Foundation
import UIKit
import RxSwift


// TODO: 팔로잉했을때 프로필창에서 숫자 변화안됨

class FollowingViewController: UIViewController {
    @IBOutlet weak var followingTableView: UITableView!
    @IBOutlet weak var followingSearchBar: UISearchBar!
    
    let apiManager = APIManager.shared
    let store = Store.shared
    let disposeBag = DisposeBag()
    let viewModel = FriendViewModel()
    
    var cellHeightsDictionary: NSMutableDictionary = [:]
  
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
        
        viewModel.inputs.loadFollwings()
        
    }
    func setBind(){
        viewModel.outputs.follwings
            .map{ $0.friends }
            .bind(to:followingTableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                print(element)
                cell.onFriend.accept(element)
            }
            .disposed(by: disposeBag)
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

