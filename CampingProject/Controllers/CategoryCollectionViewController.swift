//
//  CategoryTableViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/15.
//

import Foundation
import UIKit



class CategoryCollectionViewController: UICollectionViewController{
      
    @IBOutlet var categoryCollectionView: UICollectionView!
    
    let gearTypeVM = GearTypeViewModel()
    let userGearVM = UserGearViewModel.shared
    
    let apiManager: APIManager = APIManager.shared
    
    var gearType: Int = 0
    var tableIndex: IndexPath = []
   
  
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let type = gearTypeVM.gearTypes[gearType].gearName
        self.title = type
        userGearVM.categoryUserData(type: type)
        categoryCollectionView.register(UINib(nibName:String(describing: MyGearCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "myGearViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteTableCell(_:)), name: NSNotification.Name("DidDeleteCatogoryGearPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(_:)), name: NSNotification.Name("DidReloadPostEdit"), object: nil)
    }
    
    @objc func deleteTableCell(_ noti: Notification) {
        self.categoryCollectionView.performBatchUpdates({
            self.userGearVM.deleteCategoryData(row: tableIndex.row)
            self.categoryCollectionView.deleteItems(at: [self.tableIndex])
        }, completion: { (done) in
             //perform table refresh
        })
    
    }
    
    @objc func reloadTableView(_ noti: Notification){
        if noti.userInfo?["edit"] as! Bool{
            self.categoryCollectionView.reloadData()
        }
    }
    
  
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userGearVM.numberOfRowsInSection()
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myGearViewCell", for: indexPath) as? MyGearCollectionViewCell else { return UICollectionViewCell() }
        
        let userGearId = userGearVM.categoryData[indexPath.row].id
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
        
        if let gearName = userGearVM.categoryData[indexPath.row].name,
           let gearType = userGearVM.categoryData[indexPath.row].gearTypeName,
            let gearDate = userGearVM.categoryData[indexPath.row].buyDt {
            cell.updateUI(name: gearName, type: gearType, date: gearDate)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let first = self.userGearVM.userGears.firstIndex(where: { $0.id == self.userGearVM.categoryData[indexPath.row].id
        })!
      
        tableIndex = indexPath
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "GearDetailView") as! GearDetailViewController

        pushVC.gearRow = first
        
        
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let margin: CGFloat = 10
//        let itemSpacing: CGFloat = 10
//
//        let width = (collectionView.frame.width - margin * 2 - itemSpacing) / 2
//        let height = width * 10/7.5
//
//        return CGSize(width: width, height: height)
//    }
    
}
