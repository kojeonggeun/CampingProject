//
//  DisregisterViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2022/03/03.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DisregisterViewController: UIViewController{
    
    static let identifier = "DisregisterViewController"
    
    @IBOutlet weak var disregisterButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var checkLabel: UILabel!
    
    let disposeBag = DisposeBag()
    let viewModel = DisregisterViewModel()
    var passwordErrorHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordErrorHeight =  checkLabel.heightAnchor.constraint(equalToConstant: 0)
        passwordField.delegate = self
        passwordField.radius()
        
        passwordField.rx
        .controlEvent(.editingDidEnd)
        .withLatestFrom(passwordField.rx.text.orEmpty)
        .bind(to:viewModel.inputs.passwordText)
        .disposed(by: disposeBag)
        
        viewModel.outputs.result
            .subscribe(onNext:{ [weak self] result in
                self?.disregisterButton.isEnabled = result
                
                if result {
                    self?.passwordErrorHeight.isActive = true
                }else {
                    self?.passwordErrorHeight.isActive = false
                }
                
                UIView.animate(withDuration: 0.3){
                    self?.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        disregisterButton.rx.tap
            .subscribe(onNext:{
                let alert = UIAlertController(title: "회원 탈퇴", message: "정말 탈퇴 하실 껀가요??", preferredStyle: .alert)
                alert.addAction(.init(title: "확인", style: .cancel, handler: {_ in
                    self.viewModel.inputs.deleteUser.accept(())
                    self.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(.init(title: "취소", style: .default,handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }
}

extension DisregisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
