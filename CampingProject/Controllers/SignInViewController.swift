//
//  SignInViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/02.
//

import Foundation
import UIKit
//import AuthenticationServices


@available(iOS 13.0, *)
class SignInViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginStateButton: UIButton!
    
    @IBOutlet weak var loginCheckLabel: UILabel!
   
    @IBOutlet weak var appleLoginView: UIStackView!
    
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
                self.userManager.loadUserInfo(completion: { _ in })
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



//    TODO: 추후 소셜 로그인 구현 예정(백엔드 친구와 의논 후)
/*
    func setupAppleLogin(){
        let appleLoginButton = ASAuthorizationAppleIDButton(type:.signIn, style:.black)
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonPress), for: .touchUpInside)
        self.appleLoginView.addArrangedSubview(appleLoginButton)

    }

    @objc func appleLoginButtonPress(){
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()

    }

extension SignInViewController: ASAuthorizationControllerDelegate{
//  Apple로그인 인증 성공 시 인증 정보 반환 함수
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print(authorization.credential)
        switch authorization.credential {
            
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            
            let tokeStr = String(data: appleIDCredential.identityToken!, encoding: .utf8)
            print(tokeStr)
            print(userIdentifier, fullName, email)
            
        case let passwordCredential as ASPasswordCredential:
            let userName = passwordCredential.user
            let password = passwordCredential.password
            print(userName, password)
            
        default:
            break
    }

}
//    Apple로그인 인증 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error: \(error)")
    }
}
 
 
 extension SignInViewController: ASAuthorizationControllerPresentationContextProviding{
     
     func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
         return self.view.window!
     }
 }
*/
