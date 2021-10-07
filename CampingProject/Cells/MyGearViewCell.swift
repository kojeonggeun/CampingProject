//
//  FirstViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/10.
//

import Foundation
import UIKit

class MyGearViewCell: UITableViewCell {
    
    @IBOutlet weak var tableViewCellText: UILabel!
    
    @IBOutlet weak var tableViewCellImage: UIImageView!
    @IBOutlet weak var tableViewCellGearType: UILabel!
    @IBOutlet weak var tableViewCellDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableViewCellImage.layer.cornerRadius = 7
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomSpace: CGFloat = 15
        let topSpace: CGFloat = 15
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: topSpace, left: 0, bottom: bottomSpace, right: 0))
        }

    func updateUI(name:String, type: String, date: String){
        print(name, type, date)
        tableViewCellText.text = name
        tableViewCellGearType.text = type
        tableViewCellDate.text = date
    }
    
    
}



