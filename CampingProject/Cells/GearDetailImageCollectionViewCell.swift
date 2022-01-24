//
//  GearDetailViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/30.
//

import Foundation
import UIKit
import Alamofire

class GearDetailImageCollectionViewCell: UICollectionView {
    
    @IBOutlet weak var gearDetailImage: UIImageView!
    
    static let identifier:String = "GearDetailImageCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gearDetailImage.layer.cornerRadius = 10
    }
    
    
    func updateUI(item: UIImage) {
        
    }
}
