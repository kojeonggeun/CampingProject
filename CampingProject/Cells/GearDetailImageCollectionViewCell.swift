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
    
    static let identifier:String = "GearDetailImageCollectionViewCell"
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
//                임시 이미지 변환 코드
                if gear.url != "camera.circle"{
                    AF.request(gear.url).responseImage { response in
                        switch response.result{
                        case .success(let image):
                            print(image)
                            self!.gearDetailImage.image = image
                        case .failure(let err):
                            print(err)
                        }
                    }
                } else {
                    self!.gearDetailImage.image = UIImage(systemName: gear.url)
                }
                
            }).disposed(by: cellDisposeBag)
            
              
                
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
