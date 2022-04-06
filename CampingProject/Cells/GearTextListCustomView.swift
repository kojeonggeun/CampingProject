//
//  GearListStackViewCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/23.
//

import Foundation
import UIKit


@IBDesignable
class GearTextListCustomView: UIView{

    @IBOutlet weak var gearType: UITextField!
    @IBOutlet weak var gearName: UITextField!
    @IBOutlet weak var gearColor: UITextField!
    @IBOutlet weak var gearCompany: UITextField!
    @IBOutlet weak var gearCapacity: UITextField!
    @IBOutlet weak var gearBuyDate: UITextField!
    @IBOutlet weak var gearPrice: UITextField!
    @IBOutlet weak var gearDesc: UITextField!

    var apiManager: APIManager = APIManager.shared
    var gearTypeId: Int = 0
    var selectType: String = ""

    let pickerView = UIPickerView()
    let datePickerView = UIDatePicker()

    override func awakeFromNib() {
       super.awakeFromNib()

        gearPrice.keyboardType = .numberPad
        gearType.tintColor = .clear
        addDoneButtonOnNumpad(textField: gearPrice)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let className = String(describing: type(of: self))
        guard let view = loadViewFromNib(nib: className) else { return }

        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gearDesc.delegate = self
        createPickerView()
        createDatePickerView()

        self.addSubview(view)

    }
    func addDoneButtonOnNumpad(textField: UITextField) {
            
            let keypadToolbar: UIToolbar = UIToolbar()
            
            keypadToolbar.items=[
                UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: textField, action: #selector(UITextField.resignFirstResponder)),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
            ]
            keypadToolbar.sizeToFit()
            
            textField.inputAccessoryView = keypadToolbar
    }

    func loadViewFromNib(nib: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nib, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView

    }

    func updateData(type: String, name: String, color: String, company: String, capacity: String, buyDate: String, price: Int, desc: String ) {

        gearType.text = type
        gearName.text = name
        gearColor.text = color
        gearCompany.text = company
        gearCapacity.text = capacity
        gearBuyDate.text = buyDate
        gearPrice.text = "\(price)"
        gearDesc.text = desc
    }

    func createDatePickerView() {

        datePickerView.datePickerMode = .date
        datePickerView.timeZone = NSTimeZone.local
        datePickerView.locale = Locale(identifier: "ko_KR")
        
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        datePickerView.backgroundColor = .white
        
        let doneButton = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(dismissDatePickerView))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let toolBar = createToolbar(item: [flexibleSpace,doneButton])
        
        gearBuyDate.inputAccessoryView = toolBar
        gearBuyDate.inputView = datePickerView
    }

    @objc func dismissDatePickerView() {

        let formatter = DateFormatter()

        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy년 MM월 dd일"

        gearBuyDate.text = formatter.string(from: datePickerView.date)
        endEditing(true)

    }

    func createPickerView() {

        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white

        gearType.inputView = pickerView
        
        gearType.text = apiManager.gearTypes[0].gearName
        gearTypeId = apiManager.gearTypes[0].gearID
        selectType = apiManager.gearTypes[0].gearName
        
        let doneButton = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(dismissPickerView))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let toolBar = createToolbar(item: [flexibleSpace,doneButton])
        
        
        gearType.inputAccessoryView = toolBar
    }

    func initPickerView(type: String, id: Int) {

        gearType.text = type
        gearTypeId = id
    }
    @objc func dismissPickerView() {
        gearType.text = selectType
        gearType.resignFirstResponder()

        endEditing(true)
    }

    func createToolbar(item: [UIBarButtonItem]) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([item[0],item[1]], animated: true)
        toolbar.isUserInteractionEnabled = true
        

        return toolbar
    }
}


extension GearTextListCustomView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return apiManager.gearTypes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return apiManager.gearTypes[row].gearName
    }
}

extension GearTextListCustomView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
        selectType = apiManager.gearTypes[row].gearName
        gearTypeId = apiManager.gearTypes[row].gearID
                
    }
    
}

extension GearTextListCustomView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
}
