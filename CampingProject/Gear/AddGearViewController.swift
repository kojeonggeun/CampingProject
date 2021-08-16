//
//  AddGear.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/12.
//

import Foundation
import UIKit


class AddGearViewController: UIViewController{
    
    
    @IBOutlet weak var gearTypeTextField: UITextField!
    @IBOutlet weak var gearTypeLabel: UILabel!
    @IBOutlet weak var gearImage: UIImageView!
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    let gearManager = GearManager.shared
    let btn: UIButton = UIButton()
    
    let gg: [String] = ["텐트","타프","난로","식기","코펠","컵","이것","저것","텐트","타프","난로","식기","코펠","컵","이것","저것","텐트","타프","난로","식기","코펠","컵","이것","저것","텐트","타프","난로","식기","코펠","컵","이것","저것"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
        createPickerView()
        gearTypeTextField.tintColor = .clear

    }

    func createPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        gearTypeTextField.inputView = pickerView
        
        
    }
    


}


extension AddGearViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return gearManager.gears.count
        return gg.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return gearManager.gears[row].gearName
        return gg[row]
    }
}

extension AddGearViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        gearTypeTextField.text = gearManager.gears[row].gearName
        gearTypeLabel.text = gg[row]
        
        
    }
        
}


extension AddGearViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
