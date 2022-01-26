//
//  EmailVerificationViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/26.
//

import Foundation
import UIKit
import RxSwift

class EmailCertificationViewController: UIViewController {
    
    @IBOutlet weak var checkEmailTextField: UITextField!
    @IBOutlet weak var certificationCodeTextField: UITextField!
    @IBOutlet weak var certificationTimer: UILabel!
    
    static let identifier = "EmailVerificationViewController"
    
    var email = String()
    var sec: Int = 0
    var timer: Timer?
    
    let apiManager = APIManager.shared
    @IBAction func requstCertification(_ sender: Any) {
        apiManager.requestEmailCertificationCode(email: email){ code in
            let alert = UIAlertController(title: "인증 요청 성공", message: "이메일을 확인해 주세요", preferredStyle: .alert)
            alert.addAction(.init(title: "확인", style: .cancel))
            
            self.present(alert, animated: true, completion: nil)
           
            self.sec = 180
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    self.sec -= 1
                    self.updateTimerLabel()
                
                    }
        }
    }
    
//    MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkEmailTextField.layer.cornerRadius = 10
        certificationCodeTextField.layer.cornerRadius = 10
        checkEmailTextField.text = email
        checkEmailTextField.isUserInteractionEnabled = false
    }
    
    
    func  resetTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateTimerLabel() {
        var minutes = self.sec / 60
        var seconds = self.sec % 60
            if self.sec > 0 {
               self.certificationTimer.text = String(format: "%02d:%02d", minutes, seconds )
                
            } else {
                self.certificationTimer.text = "시간 초과"
            }
    }
}
