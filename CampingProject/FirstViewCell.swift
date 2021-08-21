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
    @IBOutlet weak var expandButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableViewCellText.textColor = UIColor.black
    }
}

struct TableViewCellData {
    var opened = Bool()
    var gearTypeName = String()
    var name = [String]()
    
}


struct CellData: Codable {
    var id: Int
    var name: String
    var gearTypeId: Int
    var gearTypeName: String
    var color: String
    var company: String
    var capacity: String
    var gearImages: [ImageData]
    
}

struct ImageData: Codable {

    var imageId: Int
    var orgFilename: String
    var url: String
}

struct CellDataResponse: Codable {
    var gears: [CellData] = []
}

