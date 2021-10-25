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
    
    @IBOutlet weak var checkTextField: UILabel!
    
    
    @IBAction func backScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let userManager: UserViewModel = UserViewModel()

    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true
        passwordConformTextField.isSecureTextEntry = true
        checkTextField.isHidden = true

        
    }
    
//    서버 작업 후 이메일 중복검사 구현 예정 
    @IBAction func signUpBtn(_ sender: Any) {
        guard let email = emailTextField.text  else{ return }
        guard let password = passwordTextField.text else{ return }
        guard let passwordConform = passwordConformTextField.text else{ return }
        
        signUpAction(email: email, password: password, passwordConform: passwordConform)
        
    }
    
    func signUpAction(email: String, password: String, passwordConform: String){
    
        
        if !userManager.isValidEmail(email: email){
            checkTextField.isHidden = false
            checkTextField.text = "이메일 형식이 맞지 않습니다."
            emailAnimation()
            return
            
        }
        
        if !userManager.isValidPassword(password: password){
            checkTextField.isHidden = false
            checkTextField.text = "비밀번호는 영어+숫자+특수문자, 8~20자리로 해야합니다."
            passwordAnimation()
            return
        }
        
//        let encrypt: String = AES256Util.encrypt(string: password)
        
        if password == passwordConform && password != "" {
            userManager.Register(email: email, password: password)
            checkTextField.isHidden = true
            
        } else {
            checkTextField.isHidden = false
            checkTextField.text = "비밀번호가 서로 다릅니다."
            passwordAnimation()
            return
        }
        
//        let alert = UIAlertController(title: nil, message: "회원가입이 완료 되었습니다.!!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
//        self.present(alert, animated: true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func passwordAnimation(){
            UIView.animate(withDuration: 0.2, animations: {
            self.passwordTextField.frame.origin.x -= 20
            self.passwordConformTextField.frame.origin.x -= 20
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.passwordTextField.frame.origin.x += 20
                    self.passwordConformTextField.frame.origin.x += 20
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.passwordTextField.frame.origin.x -= 20
                        self.passwordConformTextField.frame.origin.x -= 20
                    })
                })
            })
    }
    
    func emailAnimation(){
        UIView.animate(withDuration: 0.2, animations: {
        self.emailTextField.frame.origin.x -= 20
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.emailTextField.frame.origin.x += 20
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.emailTextField.frame.origin.x -= 20
                })
            })
        })
    }
 
    
    // 키보드 리턴키 눌렀을때 키보드 사라지게
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let email = textField.text else { return }
        
        userManager.emailDuplicateCheck(email: email, completion: { data in
            if data != 0 {
                self.checkTextField.isHidden = false
                self.checkTextField.text = "중복 되는 이메일입니다."
                self.emailAnimation()
            } else {
                self.checkTextField.isHidden = true
            }
        })
    }
}
