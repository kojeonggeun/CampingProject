//
//  SignInViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/02.
//

import Foundation
import UIKit
import AuthenticationServices

class SignInViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    let userManager: UserManager = UserManager.shared
    
    
    @IBAction func loginBtn(_ sender: Any) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
//      TODO : 아이디와 비밀번호 입력 받아 DB에 있는 데이터와 비교해서 로그인 성공 유무 체크 해야 함
        userManager.loginCheck(email: email, password: password)
        performSegue(withIdentifier: "MainTabBarController", sender: nil)
            
        
        
    }
    
    @IBAction func appleLogin(_ sender: Any) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let barVC = segue.destination as? MainTabBarController {
//                barVC.viewControllers?.forEach {
//                }
            }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true
        userManager.loadData()
        
    }
}
