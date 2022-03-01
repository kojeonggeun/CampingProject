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

import RxCocoa
import RxSwift

class AddGearViewController: UIViewController {
    var apiManager: APIManager = APIManager.shared
    
    let imagePicker = ImagePickerManager()
    let userGearViewModel = UserGearViewModel.shared
    let disposeBag = DisposeBag()
    var viewModel: MyGearViewModel!
    
    
    init(viewModel: MyGearViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
 
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "장비 등록"
        let rightBarButtonItem = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(gearSave(_:)))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        imageCount.text = "(\(imagePicker.photoArray.count) / 5"
    }
    
    @objc func gearSave(_ sender: UIButton) {
        
        guard let name = customView.gearName.text else { return }
        guard let color = customView.gearColor.text else { return }
        guard let company = customView.gearCompany.text else { return }
        guard let capacity = customView.gearCapacity.text else { return }
        guard let date = customView.gearBuyDate.text else { return }
        guard let price = customView.gearPrice.text else { return }
        
        
        self.apiManager.addGear(name: name, type: self.customView.gearTypeId, color: color, company: company, capacity: capacity, date: date ,price: price, image: self.imagePicker.photoArray, imageName: self.imagePicker.imageFileName)
            .subscribe()
            .disposed(by: disposeBag)
        
        let alert = UIAlertController(title: nil, message: "장비 등록이 완료 되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { code in
            
            self.viewModel.loadGears()
            self.navigationController?.popViewController(animated: true)
            
            
        })
        self.present(alert, animated: true)
        
    }
    
    @IBOutlet weak var gearCollectionView: UICollectionView!
    @IBOutlet weak var customView: GearTextListCustomView!
    
    @IBOutlet weak var imageCount: UILabel!
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imageSelectButton(_ sender: Any) {
        imagePicker.showMultipleImagePicker(vc: self, collection: gearCollectionView, countLabel: imageCount)
    }
    
}


extension AddGearViewController: UICollectionViewDataSource {
   
    
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
        if let indexpath: IndexPath = self.gearCollectionView?.indexPath(for: cell!) {
            imagePicker.userSelectedAssets.remove(at: indexpath.row)
            imagePicker.photoArray.remove(at: indexpath.row)
            self.gearCollectionView.deleteItems(at: [indexpath])
        }

        self.imageCount.text = "(\(imagePicker.photoArray.count) / 5"
    }

}
