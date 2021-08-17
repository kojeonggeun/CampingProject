//
//  AddGear.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/12.
//

import Foundation
import UIKit

import Photos
import BSImagePicker

class AddGearViewController: UIViewController{
    
    
    @IBOutlet weak var gearTypeTextField: UITextField!
    @IBOutlet weak var gearTypeLabel: UILabel!
    @IBOutlet weak var gearCollectionView: UICollectionView!
    
    @IBOutlet weak var gearName: UITextField!
    @IBOutlet weak var gearColor: UITextField!
    @IBOutlet weak var gearCompany: UITextField!
    @IBOutlet weak var gearCapacity: UITextField!
    
    let gearManager = GearManager.shared
    let btn: UIButton = UIButton()
    
    var selectedAssets = [PHAsset]()
    var photoArray = [UIImage]()
    var gearTypeId: Int = 0
    
    let gg: [String] = ["텐트","타프","난로","식기","코펠","컵","이것","저것","텐트","타프","난로","식기","코펠","컵","이것","저것","텐트","타프","난로","식기","코펠","컵","이것","저것","텐트","타프","난로","식기","코펠","컵","이것","저것"]
    
    @IBAction func gearSave(_ sender: Any) {
        guard let name = gearName.text else { return }
        guard let color = gearName.text else { return }
        guard let company = gearName.text else { return }
        guard let capacity = gearName.text else { return }
        
        gearManager.gearSave(name: name, type: gearTypeId, color: color, company: company, capacity: capacity, image: photoArray)
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapButton(_ sender: Any) {
//        let vc = UIImagePickerController()
//        vc.sourceType = .photoLibrary
//        vc.delegate = self
//        vc.allowsEditing = true
//        present(vc, animated: true, completion: nil)
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5
        
        self.presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            for asset in assets {
                self.selectedAssets.append(asset)
            }
            self.convertAssetToImages()
            self.gearCollectionView.reloadData()
            // User finished selection assets.
        })
    }
    
    
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

extension AddGearViewController {
    
    func convertAssetToImages(){
        if selectedAssets.count != 0{

            for i in 0..<selectedAssets.count{

                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()

                var thumbnail = UIImage()

                option.isSynchronous = true

                manager.requestImage(for: selectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result,info) -> Void in
                    thumbnail = result!
                })

                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)
                self.photoArray.append(newImage! as UIImage)
                

            }

        }

    }
}



extension AddGearViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gearManager.gears.count
//        return gg.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gearManager.gears[row].gearName
//        return gg[row]
    }
}

extension AddGearViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gearTypeTextField.text = gearManager.gears[row].gearName
        gearTypeId = gearManager.gears[row].gearID

//        gearTypeLabel.text = gg[row]


    }

}


extension AddGearViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GearImageCollectionViewCell", for: indexPath) as? GearImageCollectionViewCell else { return UICollectionViewCell() }
        print(self.photoArray[indexPath.row].pngData())
        
        cell.updateUI(item: self.photoArray[indexPath.row])
        return cell
    }
    
    
}

extension AddGearViewController: UICollectionViewDelegate{
    
}


extension AddGearViewController: UICollectionViewDelegateFlowLayout {
    // 셀 사이즈 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 5 - card(width) - 5 - card(width) - 5
        let width: CGFloat = (collectionView.bounds.width - (5 * 3))/2
        let height: CGFloat = width + 60
        return CGSize(width: width, height: height)
    }
}
