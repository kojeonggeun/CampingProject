//
//  asdf.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/06.
//

import Foundation
import UIKit
import TextFieldEffects

class GearDetailViewController: UIViewController {

    @IBOutlet weak var customView: GearTextListCustomView!
    @IBOutlet weak var imageCollectionView: UICollectionView!

    
    
    var gearRow = Int()
    var imageArray = [ImageData]()
    let apiService = APIManager.shared
    
    let userGearVM = UserGearViewModel()
    
    
    let DidDeleteGearPost: Notification.Name = Notification.Name("DidDeleteGearPost")
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showDeleteAlert(_ sender: Any) {

        let id: Int = userGearVM.userGears[gearRow].id

        let alert = UIAlertController(title: nil, message: "장비를 삭제 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "삭제", style: .default) { action in
            self.userGearVM.deleteUserGear(gearId: id, row: self.gearRow )
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: self.DidDeleteGearPost, object: nil, userInfo: ["delete": true])
            
        })
        alert.addAction(UIAlertAction(title: "취소", style: .default) { action in
            return
        })
        present(alert, animated: true, completion: nil)

    }
    @IBAction func gearEdit(_ sender: Any) {
     
        
    }
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "장비 상세"
        
        guard let type = userGearVM.userGears[gearRow].gearTypeName else { return }
        guard let name = userGearVM.userGears[gearRow].name else { return }
        guard let color = userGearVM.userGears[gearRow].color else { return }
        guard let company = userGearVM.userGears[gearRow].company else { return }
        guard let capacity = userGearVM.userGears[gearRow].capacity else { return }
        guard let buyDt = userGearVM.userGears[gearRow].buyDt else { return  }
        guard let price = userGearVM.userGears[gearRow].price else { return }
        
        customView.UpdateDate(type: type, name: name, color: color, company: company, capacity: capacity, buyDate: buyDt, price: price)
        
        self.textFieldEdit(value: false)

        apiService.loadGearImages(gearId: apiService.userGears[gearRow].id, completion: { data in
            for i in data {
                print(i)
                self.imageArray.append(i)
            }
            self.imageCollectionView.reloadData()
            
        })
    }
    
    func textFieldEdit(value: Bool) {
        let textFieldArr = [customView.gearType,customView.gearName,customView.gearColor,customView.gearCompany,customView.gearCapacity,customView.gearBuyDate,customView.gearPrice]
        for i in textFieldArr {
            i!.isUserInteractionEnabled = value
        }
        
    }
}

extension GearDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GearDetailViewCell", for: indexPath) as? GearDetailViewCell else { return UICollectionViewCell() }
        
       
        DispatchQueue.global().async {
            let url = URL(string: self.imageArray[indexPath.row].url)
            let data = try? Data(contentsOf: url!)

            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                cell.updateUI(item: image)
                }
            }
        
        return cell
    }
}

extension GearDetailViewController: UICollectionViewDelegate{
    
}

extension GearDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
