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
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        trackThumbnail.layer.cornerRadius = 4
//        trackArtist.textColor = UIColor.systemGray2
//    }
    
    func updateUI(item: UIImage?) {
        guard let image = item else { return }
        
        gearImage.image = image
        
        
     
    }
}
