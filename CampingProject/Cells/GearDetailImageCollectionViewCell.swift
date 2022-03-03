//
//  GearDetailViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/30.
//

import Foundation
import UIKit
import Alamofire
import RxSwift

class GearDetailImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gearDetailImage: UIImageView!

    static let identifier: String = "GearDetailImageCollectionViewCell"
    private let cellDisposeBag = DisposeBag()

    var disposeBag = DisposeBag()
    var onData: AnyObserver<ImageData>

    override func awakeFromNib() {
        super.awakeFromNib()
        gearDetailImage.layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {

        let data = PublishSubject<ImageData>()
        onData = data.asObserver()

        super.init(coder: coder)

        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] gear in
                self?.loadImage(urlString: gear.url)

            }).disposed(by: cellDisposeBag)
    }
    func loadImage(urlString: String) {
        let url = URL(string: urlString)
        if urlString != "camera.circle" {
            gearDetailImage.kf.setImage(with: url, placeholder: nil, completionHandler: nil)
        } else {
            gearDetailImage.image = UIImage(systemName: urlString)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
