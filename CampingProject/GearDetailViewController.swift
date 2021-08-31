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
    
    
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var gearManager: GearManager = GearManager.shared
    var gearIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gearName.text = gearManager.userGear[gearIndex].name

        gearPrice.text = String(describing: gearManager.userGear[gearIndex].price ?? 0)
        
        
        
        
    }
    
}
 
extension GearDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
        return gearManager.userGear[gearIndex].gearImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GearDetailViewCell", for: indexPath) as? GearDetailViewCell else { return UICollectionViewCell() }
     
        for i in gearManager.userGear[indexPath.row].gearImages{
            let url = URL(string: i.url)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
          
            cell.updateUI(item: image)
        }
       
        return cell
    }
}


extension GearDetailViewController: UICollectionViewDelegate{
    
}


