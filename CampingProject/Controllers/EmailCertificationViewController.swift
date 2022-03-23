//
//  EmailVerificationViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/26.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class EmailCertificationViewController: UIViewController {

    @IBOutlet weak var checkEmailTextField: UITextField!
    @IBOutlet weak var certificationCodeTextField: UITextField!
    @IBOutlet weak var certificationTimer: UILabel!
    @IBOutlet weak var passwordNextButton: UIButton!
    @IBOutlet weak var certificationCheckButton: UIButton!

    @IBOutlet weak var checkCertificationLabel: UILabel!
    static let identifier = "EmailCertificationViewController"

    let apiManager = APIManager.shared

    var email = String()
    var certificationType:emailType!
    var sec: Int = 180
    var timer: Timer?

    lazy var alertController: UIAlertController = {
        let alert = UIAlertController(title: "인증 메일 보내는 중", message: "\n\n", preferredStyle: .alert)
        alert.view.tintColor = .black
        let loading = UIActivityIndicatorView(frame: CGRect(x: 110, y: 35, width: 50, height: 50))
        loading.hidesWhenStopped = true
        loading.style = .gray
        loading.startAnimating()
        alert.view.addSubview(loading)
        return alert
    }()

// MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkEmailTextField.addLeftPadding()
        certificationCodeTextField.addLeftPadding()

        checkEmailTextField.radius()
        certificationCodeTextField.radius()
        
        checkEmailTextField.text = email
        checkEmailTextField.isUserInteractionEnabled = false
        checkCertificationLabel.isHidden = true

        certificationCodeTextField.rx.text
            .orEmpty
            .skip(1)
            .subscribe(onNext: {
                self.trimCode(code: $0)
            })
    }
//    인증 번호 요청
    @IBAction func requstCertification(_ sender: Any) {

        present(alertController, animated: true)

        apiManager.requestEmailCertificationCode(email: email,type: certificationType) { _ in
            self.dismiss(animated: true)
            let alert = UIAlertController(title: "인증 요청 성공", message: "이메일을 확인해 주세요", preferredStyle: .alert)
            alert.addAction(.init(title: "확인", style: .cancel))
            self.startTimer()
            self.present(alert, animated: true, completion: nil)
            self.certificationCheckButton.isEnabled = true
        }
    }

//    인증 번호 확인
    @IBAction func checkCertification(_ sender: Any) {
        let code = certificationCodeTextField.text!
        apiManager.checkEmailCertificationCode(email: email, code: code,type:certificationType, completion: { result in
            if result {
                self.passwordNextButton.isEnabled = true
                self.checkCertificationLabel.text = "인증이 완료되었습니다"
                self.checkCertificationLabel.textColor = .green
                self.checkCertificationLabel.isHidden = false
            } else {

                self.checkCertificationLabel.text = "인증 번호가 다릅니다"
                self.checkCertificationLabel.textColor = .red
                self.checkCertificationLabel.isHidden = false
            }
        })
    }

//  컨트롤러 이동
    @IBAction func moveController(_ sender: Any) {
        switch certificationType {
        case .REGISTER:
            guard let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: PasswordViewController.identifier) as? PasswordViewController else {return}
            passwordVC.email = email
            self.navigationController?.pushViewController(passwordVC, animated: true)
            
        case .FIND_PASSWORD:
            guard let resetVC = self.storyboard?.instantiateViewController(withIdentifier: ResetPWViewController.identifier) as? ResetPWViewController else {return}
            resetVC.email = email
            resetVC.code = self.certificationCodeTextField.text!
            self.navigationController?.pushViewController(resetVC, animated: true)
        default:
            break
        }
    }

//    인증코드 자릿수 체크(8자리)
    func trimCode(code: String) {
        if code.count >= 8 {
            let index = code.index(code.startIndex, offsetBy: 8)
            self.certificationCodeTextField.text = String(code[..<index])

        }
    }

    func startTimer() {
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
        let minutes = self.sec / 60
        let seconds = self.sec % 60
            if self.sec > 0 {
               self.certificationTimer.text = String(format: "%02d:%02d", minutes, seconds )

            } else {
                self.certificationTimer.text = "시간 초과"
                resetTimer()
            }
    }
}
