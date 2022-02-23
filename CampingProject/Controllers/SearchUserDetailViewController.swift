//
//  FriendInfoViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/12/18.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchUserDetailViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userFollower: UILabel!
    @IBOutlet weak var userFollowing: UILabel!
    @IBOutlet weak var userGear: UILabel!
    @IBOutlet weak var userDesc: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var friendCollectionView: UICollectionView!
    
    static let identifier = "SearchUserDetailViewController"
    var apiManager = APIManager.shared
    var store = Store.shared
    var profileVM = ProfileViewModel.shared
    var viewModel = SearchUserDetailViewModel()
    
    var userId: Int = 0
    
    let disposeBag = DisposeBag()
    var myGearSB: UIStoryboard?
    var user: UserInfo? = nil
    
    
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setBind()
        
    }
    
    func setView(){
        self.navigationItem.leftBarButtonItem?.title = ""
        
        friendCollectionView.register(UINib(nibName:String(describing: MyGearCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: MyGearCollectionViewCell.identifier)
        
        myGearSB = UIStoryboard(name: "MyGear", bundle: nil)
        
        viewModel.inputs.loadSearchInfo(id: userId)
    }
    
    func setBind(){
        viewModel.outputs.searchUser
            .subscribe(onNext: { userInfo in
                self.navigationItem.title = userInfo.user?.email
                self.user = userInfo
                self.userName.text = userInfo.user?.name
                self.userFollower.text = "\(userInfo.followerCnt)"
                self.userFollowing.text = "\(userInfo.followingCnt)"
                self.userGear.text = "\(userInfo.gearCnt)"
                
                self.userDesc.text = userInfo.user?.phone
                
                if userInfo.status == "FOLLOWING"{
                    self.followButton.setTitle("팔로잉☑️", for: .normal)
                    self.followButton.tintColor = .brown
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.searchGears
            .map{ $0.map { ViewGear($0) } }
            .bind(to: friendCollectionView.rx.items(cellIdentifier: MyGearCollectionViewCell.identifier,cellType: MyGearCollectionViewCell.self)) { (row, element, cell) in
                    cell.onData.onNext(element)
            }.disposed(by: disposeBag)
        
//        TODO: 로그인한 model id와 검색한 유저의 model id 가지고 장비 수정 및 삭제 권한 부여해줘야 함
        
        friendCollectionView.rx.modelSelected(ViewGear.self)
            .subscribe(onNext:{ gear in
                let pushVC = self.myGearSB?.instantiateViewController(withIdentifier: GearDetailViewController.identifier) as! GearDetailViewController
                pushVC.gearId = gear.id
                pushVC.viewModel = GearDetailViewModel(gearId: gear.id)
                self.navigationController?.pushViewController(pushVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        followButton.rx.tap
            .bind {
                if self.user?.status == "FOLLOWING" {
                    self.store.loadDeleteFollowergRx(id: self.user!.user!.id)
                        .subscribe(onNext: { result in
                            self.followButton.setTitle("팔로우", for: .normal)
                            self.followButton.tintColor = .blue
                            self.profileVM.reloadFollowing()
                        }).disposed(by: self.disposeBag)
                } else {
                    self.apiManager.followRequst(id: self.user!.user!.id, isPublic: self.user!.user!.isPublic, completion: { data in
                        self.followButton.setTitle("팔로잉☑️", for: .normal)
                        self.followButton.tintColor = .brown
                        self.profileVM.reloadFollowing()
                    })
                }
  
            }.disposed(by: disposeBag)
    }
    
}

extension SearchUserDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == friendCollectionView {
            let margin: CGFloat = 10
            let itemSpacing: CGFloat = 10
            
            let width = (collectionView.frame.width - margin * 2 - itemSpacing) / 2
            let height = width * 10/7.5

            return CGSize(width: width, height: height)
        
        }
        let width = collectionView.bounds.width / 4
        let height = collectionView.bounds.height / 1.7
        
        return CGSize(width: width, height: height)
    }
}
