//
//  GearListStackViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/23.
//

import Foundation
import UIKit

//@IBDesignable
class GearTextListCustomView: UIView{
    
    
    @IBOutlet weak var gearType: UITextField!
    @IBOutlet weak var gearName: UITextField!
    @IBOutlet weak var gearColor: UITextField!
    @IBOutlet weak var gearCompany: UITextField!
    @IBOutlet weak var gearCapacity: UITextField!
    @IBOutlet weak var gearBuyDate: UITextField!
    @IBOutlet weak var gearPrice: UITextField!
    
    var apiService: APIManager = APIManager.shared
    var gearTypeId: Int = 0
    var selectType: String = ""
    let pickerView = UIPickerView()
    let datePickerView = UIDatePicker()
    
    override func awakeFromNib() {
       super.awakeFromNib(
       )
        createPickerView()
        createDatePickerView()
        gearType.tintColor = .clear
    }
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          self.commonInit()
      }

      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          self.commonInit()
      }

      private func commonInit(){
          let className = String(describing: type(of: self))

          let bundle = Bundle.init(for: self.classForCoder)
          let view = bundle.loadNibNamed(className,
                                         owner: self,
                                         options: nil)?.first as! UIView
          view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

          self.addSubview(view)
          
      }
    
    func UpdateDate(type:String, name:String, color:String, company:String, capacity:String,buyDate:String, price:Int ){
        gearType.text = type
        gearName.text = name
        gearColor.text = color
        gearCompany.text = company
        gearCapacity.text = capacity
        gearBuyDate.text = buyDate
        gearPrice.text = "\(price)"
    }
    
    
    func createDatePickerView(){
        
        datePickerView.datePickerMode = .date
        datePickerView.timeZone = NSTimeZone.local
        datePickerView.locale = Locale(identifier: "ko_KR")
        datePickerView.preferredDatePickerStyle = .wheels
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "선택", style: .plain, target : self, action: #selector(dismissDatePickerView))
        toolbar.setItems([doneButton], animated: true)
        
        gearBuyDate.inputAccessoryView = toolbar
        gearBuyDate.inputView = datePickerView
    }
    
    @objc func dismissDatePickerView(){
        
        let formatter = DateFormatter()

        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        gearBuyDate.text = formatter.string(from: datePickerView.date)
        endEditing(true)
        
    }
    
    func createPickerView(){
        
        pickerView.delegate = self
        gearType.inputView = pickerView
        gearType.text = apiService.gearTypes[0].gearName
        gearTypeId = apiService.gearTypes[0].gearID
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(dismissPickerView))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        gearType.inputAccessoryView = toolBar
        
        
    }
    @objc func dismissPickerView() {
        gearType.text = selectType
        gearType.resignFirstResponder()
        selectType = ""

        endEditing(true)
    }
    
}
extension GearTextListCustomView: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return apiService.gearTypes.count

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return apiService.gearTypes[row].gearName

    }
}

extension GearTextListCustomView: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectType = apiService.gearTypes[row].gearName
        gearTypeId = apiService.gearTypes[row].gearID

    }

}
