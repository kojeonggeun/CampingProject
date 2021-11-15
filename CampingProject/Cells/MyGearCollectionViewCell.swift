//
//  FirstViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/10.
//

import Foundation
import UIKit

class MyGearCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var collectionViewCellImage: UIImageView!
    @IBOutlet weak var collectionViewCellGearType: UILabel!
    @IBOutlet weak var collectionViewCellText: UILabel!
    @IBOutlet weak var collectionViewCellDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionViewCellImage.layer.cornerRadius = 7
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let bottomSpace: CGFloat = 15
//        let topSpace: CGFloat = 15
//        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: topSpace, left: 0, bottom: bottomSpace, right: 0))
//        }

    func updateUI(name:String, type: String, date: String){
        collectionViewCellText.text = name
        collectionViewCellGearType.text = type
        collectionViewCellDate.text = date
    }
    
}



