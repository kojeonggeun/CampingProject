//
//  GearEditViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/26.
//

import Foundation
import UIKit
import Photos

class GearEditViewController: UIViewController {
    
    @IBOutlet weak var customView: GearTextListCustomView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imageCount: UILabel!
    
    var gearRow: Int = 0
    var allPhotos: PHFetchResult<PHAsset>?
    var imageItem = [ImageData]()
    
    let userGearVM = UserGearViewModel.shared
    let apiService = APIManager.shared
    let imagePicker = ImagePickerManager()
    
    let DidReloadPostDetailViewController: Notification.Name = Notification.Name("DidReloadPostDetailViewController")
    let DidReloadPostEdit: Notification.Name = Notification.Name("DidReloadPostEdit")
    
    @IBAction func showImagePicker(_ sender: Any) {
        imagePicker.showMultipleImagePicker(vc: self, collection: imageCollectionView, countLabel: imageCount)
    }
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userData = userGearVM.userGears[gearRow]
    
        self.allPhotos = PHAsset.fetchAssets(with: nil)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(gearEdit))

        
        customView.UpdateData(type: userData.gearTypeName!, name: userData.name!, color: userData.color!, company: userData.company!, capacity: userData.capacity!, buyDate: userData.buyDt!, price: userData.price!)
        
     
        apiService.loadGearImages(gearId: userData.id, completion: { data in
            for (index, item) in data.enumerated() {
                let asset = self.allPhotos?.object(at: index)
                self.imageItem.append(item)
                let url = URL(string: item.url)
                let data = try? Data(contentsOf: url!)
                
//              기존 이미지피커에 데이터 저장
                self.imagePicker.photoArray.append(UIImage(data: data!)!)
                self.imagePicker.userSelectedAssets.append(asset!)
                self.imagePicker.imageFileName.append(item.orgFilename)
               
            }
            self.imagePicker.total = self.imagePicker.photoArray.count
            self.imageCount.text = "\(self.imagePicker.photoArray.count) / 5"
            self.imageCollectionView.reloadData()
            
        })
//        커스텀 nib 등록
        imageCollectionView.register(UINib(nibName: "GearImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
    }
    
    @objc func gearEdit(){

        guard let name = customView.gearName.text else { return }
        guard let color = customView.gearColor.text else { return }
        guard let company = customView.gearCompany.text else { return }
        guard let capacity = customView.gearCapacity.text else { return }
        guard let date = customView.gearBuyDate.text else { return }
        guard let price = customView.gearPrice.text else { return }
        let gearId = userGearVM.userGears[gearRow].id
        let type = customView.gearTypeId
        
        self.userGearVM.editUserGear(gearId: gearId,name: name, type: type, color: color, company: company, capacity: capacity, date: date, price: price, image: self.imagePicker.photoArray, imageName: self.imagePicker.imageFileName,item: self.imageItem)
   
        let alert = UIAlertController(title: nil, message: "장비를 수정 완료 되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "수정", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: self.DidReloadPostDetailViewController, object: nil,userInfo: ["categoryDelete" : true])
            NotificationCenter.default.post(name: self.DidReloadPostEdit, object: nil, userInfo: ["edit" : true])
            
        })
        
        present(alert, animated: true, completion: nil)
    }
}

extension GearEditViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePicker.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? GearImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.imageRemoveButton.superview?.tag = indexPath.section
        cell.imageRemoveButton.tag = indexPath.row
        cell.imageRemoveButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
 
        cell.updateUI(item: imagePicker.photoArray[indexPath.row])
        
        return cell
    }
    
    
    @objc func buttonAction(_ sender: UIButton){
        
        imagePicker.total -= 1
        
        let cell: UICollectionViewCell? = (sender.superview?.superview as? UICollectionViewCell)
        if let indexpath: IndexPath = self.imageCollectionView?.indexPath(for: cell!) {
            imagePicker.userSelectedAssets.remove(at: indexpath.row)
            imagePicker.photoArray.remove(at: indexpath.row)
            self.imageCollectionView.deleteItems(at: [indexpath])
        }

        self.imageCount.text = "(\(imagePicker.photoArray.count) / 5"
    }
    
}
