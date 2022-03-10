//
//  ResetPasswordViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2022/03/10.
//

import Foundation
import UIKit

class ResetPWViewController: UIViewController{
    
    static let identifier = "ResetPWViewController"
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var checkPasswordField: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
