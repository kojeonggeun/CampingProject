//
//  SearchTableViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/15.
//

import Foundation
import UIKit
import Alamofire
import RxSwift
import RxCocoa

class SearchTableViewCell: UITableViewCell{
    
    @IBOutlet weak var searchProfileImage: UIImageView!
    @IBOutlet weak var searchEmail: UILabel!
    @IBOutlet weak var searchName: UILabel!
    
    static let identifier:String = "SearchTableViewCell"
    
    private let cellDisposeBag = DisposeBag()
    
    var disposeBag = DisposeBag()
    
    var onData: PublishRelay<SearchUser>
//    FIXME: 수정해야함 Relay를 두개로 만들어서 할지, 새로 Cell파일을 만들어서 분리해야할지, 
    var onFriend: PublishRelay<Friend>
    var image: UIImage?
    var data: Data?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    required init?(coder: NSCoder) {
        onData = PublishRelay<SearchUser>()
        onFriend = PublishRelay<Friend>()
        
        super.init(coder: coder)
        onData
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .do{
                if $0.userImageUrl != "" {
                    let url = URL(string: $0.userImageUrl)
                    self.data = try? Data(contentsOf: url!)
                }
            }
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] user in
                self?.searchEmail.text = user.email
                self?.searchName.text = user.name
                
                if user.userImageUrl != "" {
                    self?.image = UIImage(data: self?.data! ?? Data())
                    self?.searchProfileImage.image = self?.image
                    
                } else {
                    self?.searchProfileImage.image = UIImage(systemName: "camera.circle")
                }
            })
            .disposed(by: cellDisposeBag)
        
        onFriend
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .do{
                if $0.profileUrl != "" {
                    let url = URL(string: $0.profileUrl)
                    self.data = try? Data(contentsOf: url!)
                }
            }
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] user in
                self?.searchEmail.text = user.email
                self?.searchName.text = user.name
                
                if user.profileUrl != "" {
                    self?.image = UIImage(data: self?.data! ?? Data())
                    self?.searchProfileImage.image = self?.image
                    
                } else {
                    self?.searchProfileImage.image = UIImage(systemName: "camera.circle")
                }
            })
            .disposed(by: cellDisposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

