//
//  asdf.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/06.
//

import Foundation
import UIKit


class GearDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var gearName: UILabel!
    @IBOutlet weak var gearPrice: UILabel!
    
    var gearIndex = Int()
    var imageArray = [ImageData]()
    let gearManager = GearManager.shared
    
    let DidDeleteGearPost: Notification.Name = Notification.Name("DidDeleteGearPost")
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showDeleteAlert(_ sender: Any) {

        let id: Int = self.gearManager.userGear[gearIndex].id
        let typeId: Int? = self.gearManager.userGear[gearIndex].gearTypeId
        
            
        let alert = UIAlertController(title: nil, message: "장비를 삭제 하시겠습니까?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "삭제", style: .default) { action in
            self.gearManager.deleteGear(gearId: id)
            NotificationCenter.default.post(name: self.DidDeleteGearPost, object: nil, userInfo: ["gearDeleteIndex": typeId])
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .default) { action in
            return
        })
        present(alert, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gearName.text = gearManager.userGear[gearIndex].name
        gearPrice.text = String(describing: gearManager.userGear[gearIndex].price ?? 0)
        gearManager.loadGearImages(gearId: gearManager.userGear[gearIndex].id, completion: { data in
            for i in data {
                self.imageArray.append(i)
            }
            self.imageCollectionView.reloadData()
        })
      
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
