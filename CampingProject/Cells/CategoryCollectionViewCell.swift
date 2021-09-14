//
//  CategotyCollectionViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/14.
//

import Foundation
import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var categoryButton: UIButton!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryButton.tintColor = .white
        categoryButton.titleLabel?.font = UIFont.systemFont(ofSize:15, weight: .bold)
        categoryButton.backgroundColor = UIColor.lightGray
        categoryButton.layer.cornerRadius = 5

    }
       
    func updateUI(title: String){
        print(title)
        categoryButton.setTitle("\(title)", for: .normal)

    }
}

