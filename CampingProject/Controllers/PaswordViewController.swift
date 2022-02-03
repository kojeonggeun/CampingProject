//
//  PaswordViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/27.
//

import Foundation
import UIKit
import RxSwift

//TODO: 로그인화면으로 돌아가게 ㅎ야함
class PasswordViewController: UIViewController{
    
    static let identifier = "PasswordViewController"
    
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var repwTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
   
    var email = String()
    
    let apiManager = APIManager.shared
    let disposeBag = DisposeBag()
    
    @IBAction func unwind(_ sender: Any) {
        DB.userDefaults.removeObject(forKey: "token")
        DB.userDefaults.set(false, forKey: "Auto")
        ProfileViewModel.shared.clearUserCount()

        performSegue(withIdentifier: "signIn", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pwTextField.addLeftPadding()
        repwTextField.addLeftPadding()
        
        pwTextField.layer.cornerRadius = 10
        repwTextField.layer.cornerRadius = 10
        
        let pwInput = pwTextField.rx.text.orEmpty.asObservable()
        let pwVaild = pwInput.skip(1).map{ self.apiManager.isValidPassword(password: $0) }
        
        let repwInput = repwTextField.rx.text.orEmpty.asObservable()
        let repwValid = repwInput.skip(1).map{ self.pwTextField.text! == $0 }
        
        Observable.combineLatest(pwVaild, repwValid, resultSelector: {$0 && $1})
            .subscribe(onNext: { result in
                self.signUpButton.isEnabled = result
            }).disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .subscribe(onNext:{
                self.apiManager.register(email: self.email, password: self.pwTextField.text!)
                let alert = UIAlertController(title: "회원 가입", message: "가입이 완료 되었습니다", preferredStyle: .alert)
                alert.addAction(.init(title: "확인", style: .cancel, handler: {_ in
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true,completion: nil)
            }).disposed(by: disposeBag)
        
    }
}
