//
//  SignUpViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/07/29.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConformTextField: UITextField!
    
    @IBAction func backScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var user: [User] = []
    
    @IBAction func signUpBtn(_ sender: Any) {
        guard let email = emailTextField.text else{ return }
        guard let password = passwordTextField.text else{ return }
        guard let passwordConform = passwordConformTextField.text else{ return }
        
        
        
        user.append(User(email: email, password: password))
    
        print(email, password, passwordConform)
        print(user)
        print(user[0].email)
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


