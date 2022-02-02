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
    
    @IBAction func signUp(_ sender: Any) {
        apiManager.register(email: email, password: pwTextField.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pwTextField.addLeftPadding()
        repwTextField.addLeftPadding()
        
        pwTextField.layer.cornerRadius = 10
        repwTextField.layer.cornerRadius = 10

        pwTextField.autocorrectionType = .no
        
        let pwInput = pwTextField.rx.text.orEmpty.asObservable()
        let pwVaild = pwInput.skip(1).map{ self.apiManager.isValidPassword(password: $0) }
        
        let repwInput = repwTextField.rx.text.orEmpty.asObservable()
        let repwValid = repwInput.skip(1).map{ self.pwTextField.text! == $0 }
        
        Observable.combineLatest(pwVaild, repwValid, resultSelector: {$0 && $1})
            .subscribe(onNext: { result in
                self.signUpButton.isEnabled = result
            }).disposed(by: disposeBag)
        
    }
}
