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
    @IBOutlet weak var expandButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableViewCellText.textColor = UIColor.black
    }
}



