//
//  GearDetailViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/30.
//

import Foundation
import UIKit

class GearDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gearDetailImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gearDetailImage.layer.cornerRadius = 10
    }
    
    func updateUI(item: UIImage) {
        
        self.gearDetailImage.image = item
    }
}
