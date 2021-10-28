//
//  ProfileEditViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/12.
//

import UIKit
import TextFieldEffects
import Photos

class ProfileEditViewController: UIViewController {
  
    
    @IBOutlet weak var profileImageView:UIImageView!
    
    @IBOutlet weak var profileIntro: HoshiTextField!
    @IBOutlet weak var profileName: HoshiTextField!
    
    
    var image: String = ""
    var delegate: ReloadData?
    
    let imagePicker = UIImagePickerController()
    let userVM = UserViewModel.shared
    

    @IBAction func imageSelectButton(_ sender: Any) {
        self.present(self.imagePicker, animated: true)
    }
    
//    @IBAction func dismiss(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil )
//    }
    
    @IBAction func saveProfile(_ sender: Any) {
        userVM.saveUserProfileImage(image: profileImageView.image!, imageName: "asd", completion: { imageCheck in
            if imageCheck{
                self.userVM.saveUserProfile(name: self.profileName.text!, phone: "", intro: self.profileIntro.text!, public: true, completion: { saveCheck in
                    if saveCheck {
                        self.delegate?.reloadData()
                        
                        let alert = UIAlertController(title: nil, message: "프로필 수정 되었습니다", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default) { code in
                            self.navigationController?.popViewController(animated: true)
                        })
                        self.present(alert, animated: true)
                    }
                })
            }
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true //크롭기능 여부
        self.imagePicker.delegate = self
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        guard let name = self.userVM.userInfo[0].user.name else { return }
        guard let intro = self.userVM.userInfo[0].user.phone else { return }
        
        profileName.text = name
        profileIntro.text = intro
            
        DispatchQueue.global().async {
            let url = URL(string: self.image)
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                self.profileImageView.image = image
            }
        }
    }
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil // update 할 이미지
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 크롭 했을 경우 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            var fileName = url.lastPathComponent
            var fileType = url.pathExtension
            print(fileName, fileType)
        }
        self.profileImageView.image = newImage
        picker.dismiss(animated: true, completion: nil)
        
    }
}

protocol ReloadData {
    func reloadData()
}
