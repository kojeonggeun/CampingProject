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
    static let identifier:String = "EmptySearchResultCell"
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func updateLabel(text: String){
        if text != "" {
            searchResult.text = "\"\(text)\" 검색 결과 없음"
        } else {
            searchResult.text = "친구를 검색해보세요"
        }
    }
}
