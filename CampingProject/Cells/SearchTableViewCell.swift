//
//  SearchTableViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/15.
//

import Foundation
import UIKit
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    required init?(coder: NSCoder) {
        onData = PublishRelay<SearchUser>()
    
        super.init(coder: coder)
        
        onData.bind(onNext: {[weak self] user in
            self?.searchEmail.text = user.email
            self?.searchName.text = user.name

            let imageUrl = user.userImageUrl
            if imageUrl == "" {
                self?.searchProfileImage.image = UIImage(systemName: "camera.circle")
            } else {
                DispatchQueue.global().async {
                    let url = URL(string: imageUrl)
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        let image = UIImage(data: data!)
                        self?.searchProfileImage.image = image
                    }
                }
            }
        })
        .disposed(by: cellDisposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}

