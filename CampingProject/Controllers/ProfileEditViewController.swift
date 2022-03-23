//
//  ProfileEditViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/10/12.
//

import UIKit
import TextFieldEffects
import Photos
import RxSwift

class ProfileEditViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var profileIntro: HoshiTextField!
    @IBOutlet weak var profileName: HoshiTextField!

    var image: String = ""
    var imageName: String = ""

    let imagePicker = UIImagePickerController()
    let store = Store.shared
    let apiManager = APIManager.shared
    let disposeBag = DisposeBag()
    
    @IBAction func imageSelectButton(_ sender: Any) {
        self.present(self.imagePicker, animated: true)
    }


    @IBAction func saveProfile(_ sender: Any) {
        
        apiManager.saveUserProfileImage(image: profileImageView.image!, imageName: self.imageName)
            .subscribe(onNext:{ [weak self] imageSave in
                self?.saveUserProfile()
                
            }).disposed(by: disposeBag)
        
    }

// MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true // 크롭기능 여부
        self.imagePicker.delegate = self

        self.profileImageView.circular()
        let name = apiManager.userInfo?.user?.name
        let aboutMe = apiManager.userInfo?.user?.aboutMe

        self.profileName.text = name
        self.profileIntro.text = aboutMe

        DispatchQueue.global().async {
            let url = URL(string: self.image)
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                self.profileImageView.image = image
            }
        }
    }
    func saveUserProfile(){
        self.apiManager.saveUserProfile(name: self.profileName.text!, phone: "", aboutMe: self.profileIntro.text!, public: true)
            .subscribe(onNext:{ save in
                let alert = UIAlertController(title: nil, message: "프로필 수정 되었습니다", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true)
            }).disposed(by: disposeBag)
    }
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        var newImage: UIImage? // update 할 이미지

        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 크롭 했을 경우 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
            
        }
        
        if let url = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            self.imageName = url.value(forKey: "filename") as! String
        }
        
    
        self.profileImageView.image = newImage
        picker.dismiss(animated: true, completion: nil)

    }
}
