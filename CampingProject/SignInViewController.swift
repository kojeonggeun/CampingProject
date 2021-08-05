//
//  SignInViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/02.
//

import Foundation
import UIKit

class SignInViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    let userManager: UserManager = UserManager.shared
    
    
    @IBAction func loginBtn(_ sender: Any) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
//      TODO : 아이디와 비밀번호 입력 받아 DB에 있는 데이터와 비교해서 로그인 성공 유무 체크 해야 함
        if userManager.loginCheck(email: email, password: password){
            print("login")
        }
        
//        userManager.login(email: email, password: password ){ user in

            
        
        
//        performSegue(withIdentifier: "navi", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TabBarViewController {
            vc.segueText = segue.identifier
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        userManager.loadData()
        
    }
}
