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
    
    
    @IBOutlet weak var gearType: UITextField!
    @IBOutlet weak var gearName: UITextField!
    @IBOutlet weak var gearColor: UITextField!
    @IBOutlet weak var gearCompany: UITextField!
    @IBOutlet weak var gearCapacity: UITextField!
    @IBOutlet weak var gearBuyDate: UITextField!
    @IBOutlet weak var gearPrice: UITextField!
    
    
    @IBOutlet weak var imageCollectionView: UICollectionView!

    var gearIndex = Int()
    var gearSection = Int()
    var gearRow = Int()
    var imageArray = [ImageData]()
    let apiService = APIManager.shared
    
    let userGearVM = UserGearViewModel()
    
    
    let DidDeleteGearPost: Notification.Name = Notification.Name("DidDeleteGearPost")
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showDeleteAlert(_ sender: Any) {

        let id: Int = userGearVM.userGears[gearIndex].id
        
        
        let alert = UIAlertController(title: nil, message: "장비를 삭제 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "삭제", style: .default) { action in
            self.userGearVM.deleteUserGear(gearId: id, section: self.gearSection, row: self.gearRow )
            NotificationCenter.default.post(name: self.DidDeleteGearPost, object: nil, userInfo: ["delete": true])
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .default) { action in
            return
        })
        present(alert, animated: true, completion: nil)

    }
    @IBAction func gearEdit(_ sender: Any) {
     
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        guard let type = userGearVM.userGears[gearIndex].gearTypeName else { return }
        guard let name = userGearVM.userGears[gearIndex].name else { return }
        guard let color = userGearVM.userGears[gearIndex].color else { return }
        guard let company = userGearVM.userGears[gearIndex].company else { return }
        guard let capacity = userGearVM.userGears[gearIndex].capacity else { return }
        guard let buyDt = userGearVM.userGears[gearIndex].buyDt else { return  }
        guard let price = userGearVM.userGears[gearIndex].price else { return }
            
        gearType.text = type
        gearName.text = name
        gearColor.text = color
        gearCompany.text = company
        gearCapacity.text = capacity
        gearBuyDate.text = buyDt
        gearPrice.text = "\(price)"
    
        self.textFieldEdit(value: false)

        apiService.loadGearImages(gearId: apiService.userGears[gearIndex].id, completion: { data in
            for i in data {
                print(i)
                self.imageArray.append(i)
            }
            self.imageCollectionView.reloadData()
        })
    }
    
    func textFieldEdit(value: Bool) {
        let textFieldArr = [gearType,gearName,gearColor,gearCompany,gearCapacity,gearBuyDate,gearPrice]
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
