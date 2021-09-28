//
//  ProfileViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/28.
//

import Foundation
import UIKit


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://doodleipsum.com/600?shape=circle&bg=ceebff")
                      
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        profileImage.image = image
        
        profileImage.layer.cornerRadius = 50
        
    }
}
