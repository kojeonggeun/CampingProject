//
//  GearDetailViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/30.
//

import Foundation
import UIKit

class GearDetailViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var gearDetailImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    
    
    func updateUI(item: UIImage?) {
        
        guard let image = item else { return }
        self.gearDetailImage.image = image
        
    }
    
}
