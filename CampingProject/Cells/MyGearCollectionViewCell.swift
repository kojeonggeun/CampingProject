//
//  FirstViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/10.
//

import Foundation
import UIKit
import RxSwift
import Alamofire

class MyGearCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionViewCellImage: UIImageView!
    @IBOutlet weak var collectionViewCellGearType: UILabel!
    @IBOutlet weak var collectionViewCellText: UILabel!
    @IBOutlet weak var collectionViewCellDate: UILabel!

    static let identifier = "MyGearCollectionViewCell"

    private let cellDisposeBag = DisposeBag()

    var disposeBag = DisposeBag()
    let onData: AnyObserver<ViewGear>

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewCellImage.layer.cornerRadius = 7
    }

    required init?(coder: NSCoder) {
        let data = PublishSubject<ViewGear>()
        onData = data.asObserver()

        super.init(coder: coder)

        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] gear in

                self?.loadImage(urlString: gear.imageUrl)
                self?.collectionViewCellGearType.text = gear.type
                self?.collectionViewCellText.text = gear.name
                self?.collectionViewCellDate.text = gear.date

            }).disposed(by: cellDisposeBag)
    }
    func loadImage(urlString: String) {
        let url = URL(string: urlString)
        if urlString != "camera.circle" {
            collectionViewCellImage.kf.setImage(with: url, placeholder: nil, completionHandler: nil)
        } else {
            collectionViewCellImage.image = UIImage(systemName: urlString)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
