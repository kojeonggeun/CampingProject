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

struct TableViewCellData {
    var isOpened = Bool()
    var gearTypeName = String()
    var name = [String]()
    
    mutating func update(name:String){
        self.name.append(name)
    }
    
}

struct CellData: Codable {
    var id: Int
    var name: String
    var gearTypeId: Int?
    var gearTypeName: String?
    var color: String
    var company: String
    var capacity: String
    var price: Int?
    var gearImages: [ImageData]
    
}

struct ImageData: Codable {
    var imageId: Int
    var orgFilename: String
    var url: String
}



