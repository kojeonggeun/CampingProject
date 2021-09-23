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


class AddGearViewController: UIViewController {
    
    @IBOutlet weak var gearCollectionView: UICollectionView!
    
    @IBOutlet weak var customView: GearTextListCustomView!

    
    @IBOutlet weak var imageCount: UILabel!
    let btn: UIButton = UIButton()
    
    var apiService: APIManager = APIManager.shared
    var selectedAssets = [PHAsset]()
    var photoArray = [UIImage]()
    var imageFileName = [String]()

    
    var total: Int = 0
    
    let DidReloadPostMyGearViewController: Notification.Name = Notification.Name("DidReloadPostMyGearViewController")
    let pickerView = UIPickerView()
    let datePickerView = UIDatePicker()
    
    let userGearViewModel = UserGearViewModel()
    
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func imageSelectButton(_ sender: Any) {
        if self.photoArray.count >= 5{
            imageErrorAlert(vc: self)
            return
        }
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5
        
        var tempAssets = [PHAsset]()
        
        self.presentImagePicker(imagePicker, select: { (asset) in
            
            tempAssets.append(asset)
            
            if self.selectedAssets.count + tempAssets.count > 5 {
                self.imageErrorAlert(vc: imagePicker)
                imagePicker.deselect(asset: asset)
                tempAssets.remove(at: tempAssets.endIndex - 1)
            }
            
        }, deselect: { (asset) in
            if let firstIndex = tempAssets.firstIndex(where: { $0 == asset }) {
                tempAssets.remove(at: firstIndex)
            }
            else {
                return
                
            }
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            for asset in assets {
                self.selectedAssets.append(asset)
            }
            self.convertAssetToImages()
            self.imageCount.text = "(\(self.photoArray.count) / 5"
        })
    }
    
    func imageErrorAlert(vc: UIViewController){
        
        let alert = UIAlertController(title: nil, message: "이미지는 5장까지 등록 가능합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        vc.present(alert, animated: true)
        
    }
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "장비 등록"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(gearSave(_:)))
    

        imageCount.text = "(\(self.photoArray.count) / 5"
        
    }
    
    @objc func gearSave(_ sender: UIButton) {
        
        guard let name = customView.gearName.text else { return }
        guard let color = customView.gearColor.text else { return }
        guard let company = customView.gearCompany.text else { return }
        guard let capacity = customView.gearCapacity.text else { return }
        guard let date = customView.gearBuyDate.text else { return }
        guard let price = customView.gearPrice.text else { return }
        
       
        self.userGearViewModel.addUserGear(name: name, type: customView.gearTypeId, color: color, company: company, capacity: capacity, date: date ,price: price, image: photoArray, imageName: imageFileName)
        
        let alert = UIAlertController(title: nil, message: "장비 등록이 완료 되었습니다.!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { code in
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: self.DidReloadPostMyGearViewController, object: nil, userInfo: ["gearAddId": self.customView.gearTypeId])
            
        })
        self.present(alert, animated: true)
        
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
                    
                self.photoArray.append(thumbnail)
                self.imageFileName.append(asset.first!.originalFilename)
                
                self.gearCollectionView.reloadData()
            }
            self.total = selectedAssets.count
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


