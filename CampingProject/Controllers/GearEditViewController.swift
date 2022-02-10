//
//  GearEditViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/26.
//

import Foundation
import UIKit
import Photos
import RxSwift

class GearEditViewController: UIViewController {
    @IBOutlet weak var gearEditCustomView: GearTextListCustomView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imageCount: UILabel!
    
    let userGearVM = UserGearViewModel.shared
    let store = Store.shared
    let apiManager = APIManager.shared
    let imagePicker = ImagePickerManager()
    let DidReloadPostDetailViewController: Notification.Name = Notification.Name("DidReloadPostDetailViewController")
    let DidReloadPostEdit: Notification.Name = Notification.Name("DidReloadPostEdit")
    let disposeBag = DisposeBag()
    
    var gearId: Int = 0
    var gearDetail: GearDetail?
    var allPhotos: PHFetchResult<PHAsset>?
    var imageItem = [ImageData]()
    
    var customView: GearTextListCustomView? = nil
    
//    lazy var input = GearDetailViewModel.Input(loadGearDetail: Observable.just(()))
//    lazy var output = GearDetailViewModel(gearId: gearId).transform(input: input, disposeBag: disposeBag)

    @IBAction func showImagePicker(_ sender: Any) {
        imagePicker.showMultipleImagePicker(vc: self, collection: imageCollectionView, countLabel: imageCount)
    }
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allPhotos = PHAsset.fetchAssets(with: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(gearEdit))
        print(gearDetail)
        if let result = gearDetail{
            self.gearEditCustomView.initPickerView(type: result.gearTypeName!, id: result.gearTypeId!)
            self.gearEditCustomView.UpdateData(type: result.gearTypeName!, name: result.name!, color: result.color!, company: result.company!, capacity: result.capacity!, buyDate: result.buyDt!, price: result.price!, desc: result.description!)
//          TODO: data! 에러 해결해야함
            result.images.enumerated().forEach{
                let asset = self.allPhotos?.object(at: $0)
                self.imageItem.append($1)
                let url = URL(string: $1.url)
                let data = try? Data(contentsOf: url!)
                self.imagePicker.photoArray.append(UIImage(data: data!)!)
                self.imagePicker.userSelectedAssets.append(asset!)
                self.imagePicker.imageFileName.append($1.orgFilename)
                
            }
            self.imagePicker.total = self.imagePicker.photoArray.count
            self.imageCount.text = "\(self.imagePicker.photoArray.count) / 5"
            self.imageCollectionView.reloadData()
        }
        imageCollectionView.register(UINib(nibName: "GearImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
    }
    
    @objc func gearEdit(){
        
        guard let name = gearEditCustomView.gearName.text else { return }
        guard let color = gearEditCustomView.gearColor.text else { return }
        guard let company = gearEditCustomView.gearCompany.text else { return }
        guard let capacity = gearEditCustomView.gearCapacity.text else { return }
        guard let date = gearEditCustomView.gearBuyDate.text else { return }
        guard let price = gearEditCustomView.gearPrice.text else { return }
        let type = gearEditCustomView.gearTypeId
        
        self.apiManager.editGear(gearId: self.gearId,name: name, type: type, color: color, company: company, capacity: capacity, date: date, price: price, image: self.imagePicker.photoArray, imageName: self.imagePicker.imageFileName,item: self.imageItem)
            .subscribe()
            .disposed(by: self.disposeBag)
        
        let alert = UIAlertController(title: nil, message: "장비를 수정 완료 되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "수정", style: .default) { action in
            
            NotificationCenter.default.post(name: NSNotification.Name("edit"), object: nil)
            self.navigationController?.popViewController(animated: true)
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
