//
//  ResetPWEmailViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2022/03/10.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
class ResetPWEmailViewController:UIViewController{
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    let apiManager = APIManager.shared
    let disposeBag = DisposeBag()
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.addLeftPadding()
        emailField.radius()
        
        emailField.rx.text.orEmpty
            .asDriver()
            .map(apiManager.isValidEmail)
            .drive(self.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext:{
                guard let VC = self.storyboard?.instantiateViewController(withIdentifier: EmailCertificationViewController.identifier) as? EmailCertificationViewController else {return}
                VC.email = self.emailField.text!
                VC.certificationType = emailType.FIND_PASSWORD
                self.navigationController?.pushViewController(VC, animated: true)
            }).disposed(by: disposeBag)
            
    }
}
