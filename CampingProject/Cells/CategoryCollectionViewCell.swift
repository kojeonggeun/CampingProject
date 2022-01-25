//
//  CategotyCollectionViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/14.
//

import Foundation
import UIKit
import RxSwift

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryButton: UIButton!
    
    var disposeBag = DisposeBag()
    static let identifier:String  = "CategoryCollectionViewCell"
    
    override func prepareForReuse() {
      super.prepareForReuse()
          
      disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryButton.tintColor = .white
        categoryButton.titleLabel?.font = UIFont.systemFont(ofSize:15, weight: .bold)
        categoryButton.layer.cornerRadius = 5
    }
       
    func updateUI(title: String){
        
        categoryButton.setTitle("\(title)", for: .normal)
//        컬러는 따로 받아서 여러가지 색 사용
//        categoryButton.backgroundColor = UIColor.lightGray
    }
}

