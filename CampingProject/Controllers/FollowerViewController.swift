//
//  File.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/27.
//

import Foundation
import UIKit
import RxSwift

class FollowerViewController: UIViewController {
    
    @IBOutlet weak var followerTableView: UITableView!
    @IBOutlet weak var follwerSearchBar: UISearchBar!
    
    let store = Store.shared
    let apiManager = APIManager.shared
    var id: Int = 0
    
    
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
        followerTableView.keyboardDismissMode = .onDrag
        
        followerTableView.register(UINib(nibName:String(describing: SearchTableViewCell.self), bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        followerTableView.register(UINib(nibName:String(describing: EmptySearchResultCell.self), bundle: nil), forCellReuseIdentifier: "EmptySearchResultCell")
        
    }
    func setBind(){
        follwerSearchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
//            .bind(to: viewModel.inputs.searchText)
//            .disposed(by: disposeBag)
    }
}



    
   
