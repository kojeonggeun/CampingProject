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

    @IBAction func unwindVC1 (segue : UIStoryboardSegue) {}
    
    @IBAction func loginBtn(_ sender: Any) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        userManager.login(email: email, password: password) { completion in
            if completion {
                self.performSegue(withIdentifier: "MainTabBarController", sender: email)
        
            } else {
                print("로그인 실패 시 코드 작성 해야 함")
            }
        }
    }
    
    @IBAction func appleLogin(_ sender: Any) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let email = sender as? String else { return }
  
        if let barVC = segue.destination as? MainTabBarController {
                barVC.viewControllers?.forEach {
                    if let vc = $0 as? MyGearViewController{
                        vc.segueText = email
                    }
                }
            }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.object(forKey: "token") != nil {
            guard let user = UserDefaults.standard.value(forKey: "token") as? NSDictionary else { return }
            userManager.loginCheck(user: user){ (completion) in
                if completion {
                    self.performSegue(withIdentifier: "MainTabBarController", sender: user["email"])
                }
            }
        }
    }
}
