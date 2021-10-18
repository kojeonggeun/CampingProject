//
//  SearchTableViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/15.
//

import Foundation
import UIKit

class SearchTableViewCell: UITableViewCell{
    
    @IBOutlet weak var searchProfileImage: UIImageView!
    @IBOutlet weak var searchEmail: UILabel!
    @IBOutlet weak var searchName: UILabel!
    @IBOutlet weak var sendFollowButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    func updateUI(email: String, name: String){
        searchEmail.text = email
        searchName.text = name
        
    }
}
