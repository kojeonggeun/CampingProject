//
//  ResetPasswordViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2022/03/10.
//

import Foundation
import UIKit
import RxSwift

class ResetPWViewController: UIViewController{
    
    static let identifier = "ResetPWViewController"
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var checkPasswordField: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    
    let apiManager = APIManager.shared
    let disposeBag = DisposeBag()
    
    var email: String?
    var code: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordField.addLeftPadding()
        checkPasswordField.addLeftPadding()
        
        guard let checkEmail = email, let checkCode = code else { return }
        
        let pwInput = passwordField.rx.text.orEmpty.asObservable()
        let pwVaild = pwInput.skip(1).map { self.apiManager.isValidPassword(password: $0) }

        let repwInput = checkPasswordField.rx.text.orEmpty.asObservable()
        let repwValid = repwInput.skip(1).map { self.passwordField.text! == $0 }

        Observable.combineLatest(pwVaild, repwValid, resultSelector: {$0 && $1})
            .subscribe(onNext: {[weak self] result in
                self?.changeButton.isEnabled = result
            }).disposed(by: disposeBag)
        
        changeButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.apiManager.findPassword(code: checkCode, email:checkEmail , password: self.passwordField.text!)
                    
                let alert = UIAlertController(title: "변경 완료", message: "변경이 완료 되었습니다", preferredStyle: .alert)
                alert.addAction(.init(title: "확인", style: .cancel, handler: {_ in
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
    }
}
