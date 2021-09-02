//
//  GearDetailViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/30.
//

import Foundation
import UIKit

class GearDetailViewController: UIViewController {
    
    @IBOutlet weak var gearName: UILabel!
    @IBOutlet weak var gearPrice: UILabel!
    
    var gearManager: GearManager = GearManager.shared
    var gearIndex = Int()
    
    
    @IBAction func deleteGearAction(_ sender: Any) {

        self.deleteAlert()
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func deleteAlert(){
        
        let id: Int = self.gearManager.userGear[self.gearIndex].id
        let alert = UIAlertController(title: nil, message: "장비를 삭제 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
            self.gearManager.deleteGear(gearId: id)
        })
 
        
        
        present(alert, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gearName.text = gearManager.userGear[gearIndex].name
        gearPrice.text = String(describing: gearManager.userGear[gearIndex].price ?? 0)
        
    }
    
 
    
}


extension GearDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
        return gearManager.userGear[gearIndex].gearImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GearDetailViewCell", for: indexPath) as? GearDetailViewCell else { return UICollectionViewCell() }
        
        
        DispatchQueue.global().async {
            let url = URL(string: self.gearManager.userGear[self.gearIndex].gearImages[indexPath.row].url)
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


