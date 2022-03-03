//
//  ImagePickerController().swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/16.
//

import Foundation
import UIKit

class ImagePickerController: UIViewController {

    let imagePicker = UIImagePickerController()

    func imagePicker2() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }

}

extension ImagePickerController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print(info)

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
