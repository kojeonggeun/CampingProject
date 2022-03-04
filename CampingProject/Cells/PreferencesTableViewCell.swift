//
//  PreferencesViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2022/03/03.
//

import UIKit

class PreferencesTableViewCell: UITableViewCell {
    @IBOutlet weak var preferencesTitle: UILabel!
    
    static let identifier: String = "PreferencesTableViewCell"


    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
