//
//  SignUpViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/07/29.

import UIKit
import Alamofire
import RxSwift
import RxCocoa

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
    let signUpVM = SignUpViewModel()
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        emailTextField.addLeftPadding()
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 4
        self.checkEmail.isHidden = true
        

        emailTextField.rx.text.orEmpty
            .asDriver()
            .map(apiManager.isValidEmail)
            .drive(self.emailNextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
//        input
        emailNextButton.rx.tap
            .subscribe(onNext: {
                self.signUpVM.checkEmail.onNext(self.emailTextField.text!)
            }).disposed(by: disposeBag)
        
//        output
        signUpVM.hideLabel
            .asDriver(onErrorJustReturn: false)
            .drive(self.checkEmail.rx.isHidden)
            .disposed(by: disposeBag)
            
        signUpVM.showNextPage
            .subscribe(onNext:{
                if $0 {
                    let pushVC = self.storyboard?.instantiateViewController(withIdentifier: EmailCertificationViewController.identifier) as! EmailCertificationViewController
                    pushVC.email = self.emailTextField.text!
                    self.navigationController?.pushViewController(pushVC, animated: true)
                }
            }).disposed(by: disposeBag)

    }
    
    // 키보드 리턴키 눌렀을때 키보드 사라지게
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

