//
//  GearListViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/03.
//

import Foundation
import UIKit

class TabBarViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    var segueText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("awdawdawda")
        
        
        nameLabel.text = segueText
    }
}

