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
            self.startTimer()
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func checkCertification(_ sender: Any) {
//        TODO: certificationCodeTextField에 8자리 코드가 다 입력 되면 인증 버튼 활성화
//        인증이 완료되면 다음 버튼 활성화
        certificationCodeTextField.text
    }
    
    
    //    MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkEmailTextField.layer.cornerRadius = 10
        certificationCodeTextField.layer.cornerRadius = 10
        checkEmailTextField.text = email
        checkEmailTextField.isUserInteractionEnabled = false
    }
    
    func startTimer(){
        self.sec = 5
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.sec -= 1
                self.updateTimerLabel()
        }
    }
    
    func resetTimer() {
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
                resetTimer()
            }
    }
}
