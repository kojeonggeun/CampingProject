//
//  AddGear.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/12.
//

import Foundation
import UIKit


class AddGearViewController: UIViewController{
    
    @IBOutlet weak var gearTypePickerView: UIPickerView!
    
    @IBOutlet weak var gearTypeTextField: UITextField!
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let gearManager = GearManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

}

extension AddGearViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1    }
    
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gearManager.gears.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gearManager.gears[row].gearName
    }
}

extension AddGearViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gearTypeTextField.text = gearManager.gears[row].gearName
    }
        
}
