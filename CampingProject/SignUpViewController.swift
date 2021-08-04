//
//  SignUpViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/07/29.


import UIKit
import Alamofire

class SignUpViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConformTextField: UITextField!
    
    @IBAction func backScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let userManager: UserManager = UserManager()
//    TODO : POST로 넘기는 작업 해야 함 
    @IBAction func signUpBtn(_ sender: Any) {
        guard let email = emailTextField.text  else{ return }
        guard let password = passwordTextField.text else{ return }
        guard let passwordConform = passwordConformTextField.text else{ return }
        
        
        let encrypt: String = AES256Util.encrypt(string: password)
        
        if password == passwordConform && password != "" {
            userManager.Register(email: email, password: encrypt)
            
            
        } else {
            UIView.animate(withDuration: 0.2, animations: {
            self.passwordTextField.frame.origin.x -= 10
            self.passwordConformTextField.frame.origin.x -= 10
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.passwordTextField.frame.origin.x += 20
                    self.passwordConformTextField.frame.origin.x += 20
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.passwordTextField.frame.origin.x -= 10
                        self.passwordConformTextField.frame.origin.x -= 10
                    })
                })
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true
        passwordConformTextField.isSecureTextEntry = true
        
    }
    
    // 키보드 리턴키 눌렀을때 키보드 사라지게
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}


