//
//  SignUpViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/07/29.


import UIKit


class SignUpViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConformTextField: UITextField!
    
    @IBAction func backScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var user: [User] = []
    
    @IBAction func signUpBtn(_ sender: Any) {
        guard let email = emailTextField.text else{ return }
        guard let password = passwordTextField.text else{ return }
        guard let passwordConform = passwordConformTextField.text else{ return }
        
        
        
        user.append(User(email: email, password: password))
    
        print(email, password, passwordConform)
        print(user)
        print(user[0].email)
        
        // 임시 코드
        // vapor로 mysql 연동하여 get 테스트
        var url = URLComponents(string: "http://127.0.0.1:8080/userAll/")!
        let requestURL = url.url!
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: requestURL) { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }

            guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else {
                print("json to Any Error")
                return
            }
            
            print(jsonToArray)
        }
        print(dataTask.resume())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true
        passwordConformTextField.isSecureTextEntry = true
        
    }
    
    // 키보드 리턴키 눌렀을때 키보드 사라지게
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}


