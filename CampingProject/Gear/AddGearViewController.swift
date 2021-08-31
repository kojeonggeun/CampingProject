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
import TextFieldEffects


class AddGearViewController: UIViewController{
    
    @IBOutlet weak var gearTypeTextField: UITextField!
    @IBOutlet weak var gearCollectionView: UICollectionView!
    
    @IBOutlet weak var gearName: UITextField!
    @IBOutlet weak var gearColor: UITextField!
    @IBOutlet weak var gearCompany: UITextField!
    @IBOutlet weak var gearCapacity: UITextField!
    @IBOutlet weak var gearPrice: UITextField!
    
    @IBOutlet weak var imageCount: UILabel!
    
    var gearManager: GearManager = GearManager.shared
    let btn: UIButton = UIButton()
    
    var selectedAssets = [PHAsset]()
    var photoArray = [UIImage]()
    var imageFileName = [String]()
    var gearTypeId: Int = 0
    var total: Int = 0
  
    @IBAction func gearSave(_ sender: Any) {
        
        
        guard let name = gearName.text else { return }
        guard let color = gearColor.text else { return }
        guard let company = gearCompany.text else { return }
        guard let capacity = gearCapacity.text else { return }
        guard let price = gearPrice.text else { return }
        
        gearManager.gearSave(name: name, type: gearTypeId, color: color, company: company, capacity: capacity, price: price, image: photoArray, imageName: imageFileName)
     
        let alert = UIAlertController(title: nil, message: "장비 등록이 완료 되었습니다.!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true)
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imageSelectButton(_ sender: Any) {
        if self.photoArray.count >= 5{
            imageErrorAlert()
        }
        
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
            self.imageCount.text = "(\(self.photoArray.count) / 5"
            
            // User finished selection assets.
        })
        
        
    }
    
    func imageErrorAlert(){
        
        let alert = UIAlertController(title: nil, message: "이미지는 5장까지 등록 가능합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        gearTypeTextField.tintColor = .clear
        imageCount.text = "(\(self.photoArray.count) / 5"
        
    }

 
    func createPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        gearTypeTextField.inputView = pickerView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(sender)
    }
}

extension AddGearViewController {
    func convertAssetToImages(){
    
            for i in total..<selectedAssets.count{
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                let asset = PHAssetResource.assetResources(for: selectedAssets[i])
                
                var thumbnail = UIImage()

                option.isSynchronous = true
                manager.requestImage(for: selectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result,info) -> Void in
                    thumbnail = result!
                })

                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)
    
                self.photoArray.append(newImage! as UIImage)
                self.imageFileName.append(asset.first!.originalFilename)
                
                self.gearCollectionView.reloadData()
            }
            self.total = selectedAssets.count
    }
}



extension AddGearViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }

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
        gearTypeId = gearManager.gears[row].gearID



    }

}


extension AddGearViewController: UICollectionViewDataSource {
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GearImageCollectionViewCell", for: indexPath) as? GearImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.imageRemoveButton.superview?.tag = indexPath.section
        cell.imageRemoveButton.tag = indexPath.row
        cell.imageRemoveButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        cell.updateUI(item: self.photoArray[indexPath.row])
        
        
        return cell
    }
    
    @objc func buttonAction(_ sender: UIButton){
        
        self.total -= 1
        
        let cell: UICollectionViewCell? = (sender.superview?.superview as? UICollectionViewCell)
        if let indexpath: IndexPath = self.gearCollectionView?.indexPath(for: cell!) {
            self.selectedAssets.remove(at: indexpath.row)
            self.photoArray.remove(at: indexpath.row)
            self.gearCollectionView.deleteItems(at: [indexpath])
        }
        self.imageCount.text = "(\(self.photoArray.count) / 5"
    }

}


extension AddGearViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
    }
 
   
}

//extension AddGearViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // 5 - card(width) - 5 - card(width) - 5
//        let width: CGFloat = (collectionView.bounds.width - (30 * 3))
//
//        let height: CGFloat = width + 60
//        return CGSize(width: width, height: height)
//    }
//}


