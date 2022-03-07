//
//  ChangePasswordViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2022/03/03.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ChangePasswordViewController: UIViewController {
    static let identifier = "ChangePasswordViewController"

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordCheckField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    let disposeBag = DisposeBag()
    let apiManager = APIManager.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordField.addLeftPadding()
        passwordCheckField.addLeftPadding()

        let pwInput = passwordCheckField.rx.text.orEmpty.asObservable()
        let pwVaild = pwInput.skip(1).map { APIManager().isValidPassword(password: $0) }
        
        let repwInput = passwordCheckField.rx.text.orEmpty.asObservable()
        let repwValid = repwInput.skip(1).map { self.passwordField.text! == $0 }
        
        Observable.combineLatest(pwVaild, repwValid, resultSelector: {$0 && $1})
            .subscribe(onNext: { result in
                self.doneButton.isEnabled = result
            })
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .subscribe(onNext:{
                self.apiManager.changePassword(password: self.passwordField.text!, id: self.apiManager.userInfo!.user!.id)
                let alert = UIAlertController(title: "변경 완료", message: "비밀번호가 변경되었습니다", preferredStyle: .alert)
                alert.addAction(.init(title: "확인", style: .cancel, handler: {_ in 
                    self.navigationController?.popViewController(animated: true)
                }))

                self.present(alert, animated: true, completion: nil)
                
            })
            .disposed(by: disposeBag)
    
    }
}
