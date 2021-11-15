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
    @IBOutlet weak var loginStateButton: UIButton!
    
    @IBOutlet weak var loginCheckLabel: UILabel!
    
    let userManager: UserViewModel = UserViewModel.shared
    let apiManager: APIManager = APIManager.shared
    @IBAction func unwindVC1 (segue : UIStoryboardSegue) {}
    
    @IBAction func loginBtn(_ sender: Any) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        userManager.login(email: email, password: password) { completion in
            if completion {
                self.apiManager.loadUserGear(){ data in
                    self.userManager.loadUserInfo(completion: {_ in })
                }
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
    
    @IBAction func appleLogin(_ sender: Any) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
    }
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.isSecureTextEntry = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fieldDataInit()
        
        if DB.userDefaults.bool(forKey: "Auto") {
            if DB.userDefaults.object(forKey: "token") != nil {
                let user = DB.userDefaults.value(forKey: "token") as! NSDictionary
                print(user["token"])
                self.userManager.loadUserInfo(completion: {_ in })
                userManager.loginCheck(){ (completion) in
                    if completion {
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
