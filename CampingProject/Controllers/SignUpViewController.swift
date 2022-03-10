//
//  SignUpViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/07/29.

import UIKit
import Alamofire
import RxSwift
import RxCocoa

class SignUpNavigationViewController: UINavigationController{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


class SignUpViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkEmail: UILabel!
    @IBOutlet weak var emailNextButton: UIButton!

    @IBAction func backScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    let apiManager = APIManager.shared
    let store = Store.shared
    let signUpVM = SignUpViewModel()
    let disposeBag: DisposeBag = DisposeBag()

    private lazy var input = SignUpViewModel.Input(checkEmail: emailNextButton.rx.tap.map {
        self.emailTextField.text!
    })
    private lazy var output = signUpVM.transform(input: input, disposeBag: disposeBag)

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

        output.hideLabel
            .asDriver(onErrorJustReturn: false)
            .drive(self.checkEmail.rx.isHidden)
            .disposed(by: disposeBag)

        output.showNextPage
            .subscribe(onNext: {
              if $0 {
                  guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: EmailCertificationViewController.identifier) as? EmailCertificationViewController else {return}
                  pushVC.email = self.emailTextField.text!
                  pushVC.certificationType = emailType.REGISTER
                  self.navigationController?.pushViewController(pushVC, animated: true)
              }
            })
            .disposed(by: disposeBag)
    }

    // 키보드 리턴키 눌렀을때 키보드 사라지게
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
