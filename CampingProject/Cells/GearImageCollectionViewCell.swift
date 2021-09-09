//
//  ImageCollectionViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/17.
//

import Foundation
import UIKit

class GearImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gearImage: UIImageView!
    @IBOutlet weak var imageRemoveButton: UIButton!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//
//    }
    func updateUI(item: UIImage?) {
        guard let image = item else { return }
        gearImage.image = image
    }
    
}
