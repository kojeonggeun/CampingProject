//
//  CategoryTableViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/15.
//

import Foundation
import UIKit



class CategoryTableViewController: UITableViewController{
      
    
    
    @IBOutlet var categoryTableView: UITableView!
    
    let gearTypeVM = GearTypeViewModel()
    let userGearVM = UserGearViewModel()
    let tableViewVM = TableViewViewModel()
    let apiManager: APIManager = APIManager.shared
    
    var gearType: Int = 0
    var categoryData: [CellData] = []
    var tableIndex: IndexPath = []
   
  
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let type = gearTypeVM.gearTypes[gearType].gearName
        self.title = type
    
        for i in userGearVM.userGears{
            if i.gearTypeName == type {
                categoryData.append(i)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        
//        self.categoryTableView.performBatchUpdates({
//            
//            self.categoryTableView.deleteRows(at: [tableIndex], with: .fade)
//        }, completion: { (done) in
//             //perform table refresh
//            self.categoryTableView.reloadData()
//        })
        
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableView", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        
        let userGearId = categoryData[indexPath.row].id
        
        if let cacheImage = self.apiManager.imageCache.image(withIdentifier: "\(userGearId)") {
            DispatchQueue.main.async {
                cell.categoryImage.image = cacheImage
            }
            
        } else {
            apiManager.loadGearImages(gearId: userGearId, completion: { data in
                DispatchQueue.global().async {
                    if !data.isEmpty {
                        let url = URL(string: data[0].url)
                        let data = try? Data(contentsOf: url!)
                        let image = UIImage(data: data!)
                        DispatchQueue.main.async {
                            cell.categoryImage.image = image
                            
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.categoryImage.image = self.apiManager.imageCache.image(withIdentifier: "\(userGearId)")!
                        }
                    }
                }
            })
        }
        
        if let gearName = categoryData[indexPath.row].name,
           let gearType = categoryData[indexPath.row].gearTypeName {
            cell.updateUI(name: gearName, type: gearType)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        TODO: 카테고리에서 삭제 후 문제 생김!!!
        let first = self.userGearVM.userGears.firstIndex(where: { $0.id == self.categoryData[indexPath.row].id
        })!
      
        tableIndex = indexPath
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "GearDetailView") as! GearDetailViewController
        
        pushVC.gearRow = first
        
        self.navigationController?.pushViewController(pushVC, animated: true)
        
    }
    

 
}


