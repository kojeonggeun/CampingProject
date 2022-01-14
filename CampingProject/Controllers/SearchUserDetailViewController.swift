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
    
    
    var apiManager = APIManager.shared
    var userVM = UserViewModel.shared
    var profileVM = ProfileViewModel.shared
    
    var userId: Int = 0

    
    let disposeBag = DisposeBag()
    
    
//    MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendCollectionView.register(UINib(nibName:String(describing: MyGearCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "myGearViewCell")
        
            self.userVM.loadFriendInfoRx(id: userId)
            .subscribe(onNext: { userInfo in
                self.title = userInfo.user?.email
                self.userName.text = userInfo.user?.name
                self.userFollower.text = "\(userInfo.followerCnt)"
                self.userFollowing.text = "\(userInfo.followingCnt)"
                self.userDesc.text = userInfo.user?.phone
                
                if userInfo.status == "FOLLOWING"{
                    self.followButton.setTitle("팔로잉☑️", for: .normal)
                    self.followButton.tintColor = .brown
                }
            })
        
//
//           TODO: 이제 bind 이용해서 만들어서줘야 해!!
        SearchUserDetailViewModel.shared.loadSearchGear(id: userId)

        SearchUserDetailViewModel.shared.searchGearObservable
            .bind(to: friendCollectionView.rx.items(cellIdentifier: "myGearViewCell",cellType: MyGearCollectionViewCell.self)) { (row, element, cell) in
                UserViewModel.shared.loadGearImagesRx(id:element.id)
                    .subscribe(onNext: { image in
                        cell.collectionViewCellImage.image = image
                    })
                if let name = element.name ,
                   let gearTypeName = element.gearTypeName,
                   let buyDt = element.buyDt {
                    cell.updateUI(name: name, type: gearTypeName, date: buyDt)
                }
    
            }.disposed(by: disposeBag)
        
        followButton.rx.tap
            .bind {
                print("awdawdaw")
            }.disposed(by: disposeBag)
            
        

        
    }
    @IBAction func followBtn(_ sender: Any) {
        
//        if userInfo?.status! == "FOLLOWING" {
//            userVM.loadDeleteFollowergRx(id: userInfo!.user!.id)
//                .subscribe(onNext: { result in
//                    self.followButton.setTitle("팔로우", for: .normal)
//                    self.followButton.tintColor = .blue
//                    self.profileVM.reloadFollowing()
//                }).disposed(by: disposeBag)
//        } else {
//            apiManager.followRequst(id: userInfo!.user!.id, isPublic: userInfo!.user!.isPublic, completion: { data in
//                self.followButton.setTitle("팔로잉☑️", for: .normal)
//                self.followButton.tintColor = .brown
//                self.profileVM.reloadFollowing()
//            })
//        }
    }
    
}

//extension FriendInfoViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return userSerachGear.count
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        return userSerachGear[indexPath.row].collectionView(collectionView, cellForItemAt: indexPath)
//        return UICollectionViewCell()
//    }
//    
//    
//}


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
