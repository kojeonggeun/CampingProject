//
//  MyGearViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/06.
//

import Foundation
import UIKit

class MyGearViewModel: MyGearRepresentable {
    
    let myGear: CellData
    
    let apiManager = APIManager.shared
    let userVM = UserViewModel.shared
    let userGearVM = UserGearViewModel.shared
    
    init(myGear: CellData) {
        self.myGear = myGear
    }
        
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myGearViewCell", for: indexPath) as? MyGearCollectionViewCell else { return UICollectionViewCell() }
        
        let userGearId = self.userGearVM.userGears[indexPath.row].id
        
        if let cacheImage = self.apiManager.imageCache.image(withIdentifier: "\(userGearId)") {
            DispatchQueue.main.async {
                cell.collectionViewCellImage.image = cacheImage
            }

        } else {
            apiManager.loadGearImages(gearId: userGearId, completion: { data in
                DispatchQueue.global().async {
                    if !data.isEmpty {
                        let url = URL(string: data[0].url)
                        let data = try? Data(contentsOf: url!)
                        let image = UIImage(data: data!)
                        DispatchQueue.main.async {
                            cell.collectionViewCellImage.image = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.collectionViewCellImage.image = self.apiManager.imageCache.image(withIdentifier: "\(userGearId)")!
                        }
                    }
                }
            })
        }
        
        if let gearName = myGear.name,
           let gearType = myGear.gearTypeName,
           let gearDate = myGear.buyDt {
            
            cell.updateUI(name: gearName, type: gearType, date: gearDate)
        }
        
        return cell
    }
}
