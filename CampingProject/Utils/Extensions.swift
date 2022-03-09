//
//  Extensions.swift
//  CampingProject
//
//  Created by 고정근 on 2022/03/09.
//

import UIKit

extension UIViewController {
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
    }
    
    func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -(keyboardSize.height + self.tabBarController!.view.frame.origin.y))
            })
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        self.view.transform = .identity

        
    }
}
