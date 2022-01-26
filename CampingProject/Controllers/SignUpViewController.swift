//
//  SignUpViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/07/29.

import UIKit
import Alamofire
import RxSwift


class SignUpViewController: UIViewController {

  
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var checkEmail: UILabel!
    
    @IBOutlet weak var emailNextButton: UIButton!
    @IBAction func backScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let apiManager = APIManager.shared
    let userVM = UserViewModel.shared
    let disposeBag: DisposeBag = DisposeBag()
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 4
        self.checkEmail.isHidden = true
        emailTextField.rx.text.orEmpty
            .map(apiManager.isValidEmail)
            .subscribe(onNext: { [weak self]result in
                self?.emailNextButton.isEnabled = result
            }).disposed(by: disposeBag)
        
    }

    @IBAction func emailVerification(_ sender: Any) {
        guard let email = self.emailTextField.text else { return }
        self.userVM.emailDuplicateCheckRx(email: self.emailTextField.text!)
            .subscribe(onNext: { result in
                if result {
                    self.checkEmail.isHidden = false
                    
                } else {
                    self.checkEmail.isHidden = true
                    let pushVC = self.storyboard?.instantiateViewController(withIdentifier: EmailCertificationViewController.identifier) as! EmailCertificationViewController
                    pushVC.email = email
                    self.navigationController?.pushViewController(pushVC, animated: true)
                }
                
            })

    }
    
    // 키보드 리턴키 눌렀을때 키보드 사라지게
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
