//
//  CategoryTableViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/15.
//

import Foundation
import UIKit

class CategoryTableViewCell: UITableViewCell{
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomSpace: CGFloat = 15
        let topSpace: CGFloat = 15
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: topSpace, left: 0, bottom: bottomSpace, right: 0))
        }

    func updateUI(name:String, type: String){
        
        categoryName.text = name
        categoryType.text = type
    }
    
}
