//
//  NoSearchResultCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/26.
//

import Foundation
import UIKit

class EmptySearchResultCell: UITableViewCell {
    @IBOutlet weak var searchResult: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchResult.text = "친구를 검색해보세요"
    }
    
//    func updateLabel(text: String){
//        if text != "" {
//            searchResult.text = "\"\(text)\" 친구는 아직 ,,,"
//        } else {
//            searchResult.text = "친구를 검색해보세요"
//        }
//    }
}
