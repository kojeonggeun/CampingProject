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
import Kingfisher

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchProfileImage: UIImageView!
    @IBOutlet weak var searchEmail: UILabel!
    @IBOutlet weak var searchName: UILabel!

    static let identifier: String = "SearchTableViewCell"

    private let cellDisposeBag = DisposeBag()

    var disposeBag = DisposeBag()

    var onData: PublishRelay<SearchUser>
    var onFriend: PublishRelay<Friend>

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    required init?(coder: NSCoder) {
        onData = PublishRelay<SearchUser>()
        onFriend = PublishRelay<Friend>()

        super.init(coder: coder)
        onData
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] user in
                self?.loadImage(urlString: user.userImageUrl)
                self?.searchEmail.text = user.email
                self?.searchName.text = user.name

            })
            .disposed(by: cellDisposeBag)

        onFriend
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] user in
                self?.loadImage(urlString: user.profileUrl)
                self?.searchEmail.text = user.email
                self?.searchName.text = user.name
            })
            .disposed(by: cellDisposeBag)
    }

    func loadImage(urlString: String) {
        let url = URL(string: urlString)

        if url == nil {
            searchProfileImage.image = UIImage(systemName: "camera.circle")
        } else {
            searchProfileImage.kf.setImage(with: url, placeholder: nil, completionHandler: nil)
        }

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()

        self.searchProfileImage.image = nil
        self.searchEmail.text = nil
        self.searchName.text = nil
    }
}
