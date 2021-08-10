//
//  FirstViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/10.
//

import Foundation
import UIKit

class FirstViewCell: UITableViewCell {
    @IBOutlet weak var tableViewCellText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableViewCellText.textColor = UIColor.black
    }
}

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
    
}


