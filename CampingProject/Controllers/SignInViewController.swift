//
//  SignInViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/02.
//

import Foundation
import UIKit
import RxSwift
import RxViewController
//import AuthenticationServices


@available(iOS 13.0, *)
class SignInViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginCheckLabel: UILabel!
    @IBOutlet weak var appleLoginView: UIStackView!
    @IBOutlet weak var loginStateButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    let store: Store = Store.shared
    let apiManager: APIManager = APIManager.shared
    let viewModel = SignInViewModel()
    let disposeBag = DisposeBag()
    
    @IBAction func unwindVC1 (segue : UIStoryboardSegue) {}
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
    }
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.isSecureTextEntry = true
        setBind()
        
    }
    func setBind(){
        emailTextField.rx.text.orEmpty
            .bind(to:viewModel.inputs.emailValueChanged)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to:viewModel.inputs.pwValueChanged)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.inputs.loginButtonTouched)
            .disposed(by: disposeBag)
        
        let emailVaild = viewModel.outputs.emailVaild
        let passwordVaild = viewModel.outputs.passwordVaild
        
        Observable.combineLatest(emailVaild, passwordVaild, resultSelector: {$0 && $1})
        .subscribe(onNext: { result in
            self.loginButton.isEnabled = result
        })
        .disposed(by: disposeBag)
        
        loginStateButton.rx.tap
            .map { false }
            .subscribe(onNext: { [weak self] status in
                self?.viewModel.inputs.autoLoginStatusChanged.accept(!status)
            })
            .disposed(by: disposeBag)
        
        
        viewModel.outputs.autoLogin
            .subscribe(onNext: { [weak self] result in
                if result {
                    self?.loginStateButton.tintColor = .green
                    
                }else {
                    self?.loginStateButton.tintColor = .lightGray
                    
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.loginResult
            .subscribe(onNext: { [weak self] result in
                if result {
                    self?.performSegue(withIdentifier: "MainTabBarController",sender: nil)
                } else {
                    self?.loginCheckLabel.text = "이메일 또는 비밀번호가 틀립니다."
                }
            })
            .disposed(by: disposeBag)
        
        rx.viewWillAppear.subscribe({_ in
            self.fieldDataInit()
            
            if DB.userDefaults.bool(forKey: "Auto") && DB.userDefaults.value(forKey: "token") != nil{
                
                self.apiManager.loginCheck(){ comple in
                    if comple{
                        UserViewModel()
                        self.performSegue(withIdentifier: "MainTabBarController",sender: nil)
                    }
                }
            }
        }).disposed(by: disposeBag)
        
    }
    func fieldDataInit(){
        emailTextField.text = ""
        passwordTextField.text = ""
        loginCheckLabel.text = ""
        loginStateButton.tintColor = .lightGray
        loginStateButton.isSelected = false
        
        viewModel.inputs.emailValueChanged.accept("")
        viewModel.inputs.pwValueChanged.accept("")
        viewModel.inputs.autoLoginStatusChanged.accept(false)
        
    }
}
