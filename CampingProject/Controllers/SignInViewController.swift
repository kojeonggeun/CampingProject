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
                print("로그인 실패 시 코드 작성 해야 함")
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
        guard let email = sender as? String else { return }
  
        if let barVC = segue.destination as? MainTabBarController {
                barVC.viewControllers?.forEach {
                    if let nav = $0 as? UINavigationController{
                        let vc = nav.topViewController as! MyGearViewController
                        vc.segueText = email
                    }
                }
            }
    }
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
        
        
        passwordTextField.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
        
        if DB.userDefaults.bool(forKey: "Auto") {
            if DB.userDefaults.object(forKey: "token") != nil {
                let user = DB.userDefaults.value(forKey: "token") as! NSDictionary
                print(user["token"])
                self.userManager.loadUserInfo(completion: {_ in })
                userManager.loginCheck(){ (completion) in
                    if completion {
                        self.performSegue(withIdentifier: "MainTabBarController", sender: user["email"])
                    }
                }
            }
        }
    }// end func
    
//    TODO: 자동로그인 손봐야함 이상하다. 유저 데이터가 없는 경우가 생김
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }// end func
    
}
