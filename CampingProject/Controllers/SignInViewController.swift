//
//  SignInViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/02.
//

import Foundation
import UIKit
import RxSwift
//import AuthenticationServices


@available(iOS 13.0, *)
class SignInViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginStateButton: UIButton!
    
    @IBOutlet weak var loginCheckLabel: UILabel!
   
    @IBOutlet weak var appleLoginView: UIStackView!
    
    let store: Store = Store.shared
    let apiManager: APIManager = APIManager.shared
    @IBAction func unwindVC1 (segue : UIStoryboardSegue) {}
    
    @IBAction func loginBtn(_ sender: Any) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        apiManager.login(email: email, password: password) { completion in
            if completion {
                UserViewModel()
                self.performSegue(withIdentifier: "MainTabBarController", sender: email)
                
            } else {
//                loginCheckLabel.isHidden = false
                self.loginCheckLabel.text = "이메일 또는 비밀번호가 틀립니다."
                
            }
        }
    }
    
    @IBAction func autoLogin(_ sender: UIButton) {
        
        if sender.isSelected{
            sender.isSelected = false
            loginStateButton.tintColor = .lightGray
            DB.userDefaults.set(sender.isSelected, forKey: "Auto")
        } else {
            sender.isSelected = true
            loginStateButton.tintColor = .green
            DB.userDefaults.set(sender.isSelected, forKey: "Auto")
        }
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
    }
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.isSecureTextEntry = true
//        setupAppleLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fieldDataInit()
        
        if DB.userDefaults.bool(forKey: "Auto") {
            if DB.userDefaults.object(forKey: "token") != nil {
                let user = DB.userDefaults.value(forKey: "token") as! NSDictionary
                print(user["token"])
                apiManager.loginCheck(){ (completion) in
                    if completion {
                        UserViewModel()
                        self.performSegue(withIdentifier: "MainTabBarController",sender: nil)
                    }
                }
            }
        }
    }// end func
    func fieldDataInit(){
        emailTextField.text = ""
        passwordTextField.text = ""
        loginCheckLabel.text = ""
        loginStateButton.tintColor = .lightGray
        loginStateButton.isSelected = false
        
    }
    
}
