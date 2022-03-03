//
//  File.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/27.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FollowerViewController: UIViewController {

    @IBOutlet weak var followerTableView: UITableView!
    @IBOutlet weak var follwerSearchBar: UISearchBar!

    let store = Store.shared
    let apiManager = APIManager.shared
    let viewModel = FollowerViewModel()
    let disposeBag = DisposeBag()

    var cellHeightsDictionary: NSMutableDictionary = [:]
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

// MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setBind()
        setView()

    }

    func setView() {
        followerTableView.keyboardDismissMode = .onDrag

        followerTableView.register(UINib(nibName: String(describing: SearchTableViewCell.self), bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        followerTableView.register(UINib(nibName: String(describing: EmptySearchResultCell.self), bundle: nil), forCellReuseIdentifier: "EmptySearchResultCell")

        viewModel.inputs.loadFollwers()

    }

    func setBind() {
        viewModel.outputs.follwers
            .asDriver(onErrorJustReturn: [])
            .drive(followerTableView.rx.items) { (tableView, row, element) in
                if element.id == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptySearchResultCell.identifier, for: IndexPath(row: row, section: 0)) as? EmptySearchResultCell
                    else { return UITableViewCell()}
                    self.followerTableView.allowsSelection = false
                    cell.updateLabel(text: element.name)
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as? SearchTableViewCell
                    else { return UITableViewCell()}
                    self.followerTableView.allowsSelection = true
                    cell.onFriend.accept(element)
                    return cell
                }
            }
            .disposed(by: disposeBag)

        follwerSearchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.inputs.searchText)
            .disposed(by: disposeBag)

        followerTableView.rx.didScroll
            .subscribe { [weak self] _ in
            guard let self = self else { return }

            let offsetY = self.followerTableView.contentOffset.y
            let contentSize = self.followerTableView.contentSize.height
            let boundsSizeHeight = self.followerTableView.bounds.size.height - 50

            if offsetY > (contentSize - boundsSizeHeight) {
                self.viewModel.fetchMoreDatas.accept(())
            }
        }
        .disposed(by: disposeBag)

        viewModel.outputs.isLoadingSpinnerAvaliable
            .subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                  let self = self else { return }
            self.followerTableView.tableFooterView = isAvaliable ? self.viewSpinner : UIView(frame: .zero)
        }
        .disposed(by: disposeBag)

        followerTableView.rx.modelSelected(Friend.self)
            .subscribe(onNext: { friend in
                guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: SearchUserDetailViewController.identifier) as? SearchUserDetailViewController else {return}
                pushVC.userId = friend.friendId
                self.navigationController?.pushViewController(pushVC, animated: true)
            }).disposed(by: disposeBag)
    }
}

extension FollowerViewController: UITableViewDelegate {

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

