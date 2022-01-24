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
//                임시 이미지 변환 코드
                if gear.imageUrl != "camera.circle"{
                    AF.request(gear.imageUrl).responseImage { response in
                        switch response.result{
                        case .success(let image):
                            
                            self!.collectionViewCellImage.image = image
                        case .failure(let err):
                            print(err)
                        }
                    }
                } else {
                    self!.collectionViewCellImage.image = UIImage(systemName: gear.imageUrl)
                }
                
                self?.collectionViewCellGearType.text = gear.type
                self?.collectionViewCellText.text = gear.name
                self?.collectionViewCellDate.text = gear.date
                
            }).disposed(by: cellDisposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}



