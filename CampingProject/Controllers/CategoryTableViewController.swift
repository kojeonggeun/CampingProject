//
//  CategoryTableViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/15.
//

import Foundation
import UIKit


// TODO: 카테고리에서 사진 수정 후 리로드 안된다
class CategoryTableViewController: UITableViewController{
      
    @IBOutlet var categoryTableView: UITableView!
    
    let gearTypeVM = GearTypeViewModel()
    let userGearVM = UserGearViewModel.shared
    let tableViewVM = TableViewViewModel()
    let apiManager: APIManager = APIManager.shared
    
    var gearType: Int = 0
    var tableIndex: IndexPath = []
   
  
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let type = gearTypeVM.gearTypes[gearType].gearName
        self.title = type
        userGearVM.categoryUserData(type: type)
     
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteTableCell(_:)), name: NSNotification.Name("DidDeleteCatogoryGearPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(_:)), name: NSNotification.Name("DidReloadPostEdit"), object: nil)
    }
    
    @objc func deleteTableCell(_ noti: Notification) {
        self.categoryTableView.performBatchUpdates({
            self.userGearVM.deleteCategoryData(row: tableIndex.row)
            self.categoryTableView.deleteRows(at: [self.tableIndex], with: .fade)
        }, completion: { (done) in
             //perform table refresh
        })
    
    }
    
    @objc func reloadTableView(_ noti: Notification){
        if noti.userInfo?["edit"] as! Bool{
            self.categoryTableView.reloadData()
        }
    }
    
  
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userGearVM.numberOfRowsInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableView", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        
        let userGearId = userGearVM.categoryData[indexPath.row].id
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
        
        if let gearName = userGearVM.categoryData[indexPath.row].name,
           let gearType = userGearVM.categoryData[indexPath.row].gearTypeName {
            cell.updateUI(name: gearName, type: gearType)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let first = self.userGearVM.userGears.firstIndex(where: { $0.id == self.userGearVM.categoryData[indexPath.row].id
        })!
      
        tableIndex = indexPath
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "GearDetailView") as! GearDetailViewController
        pushVC.tableIndex = indexPath
        pushVC.gearRow = first
        
        
        self.navigationController?.pushViewController(pushVC, animated: true)
        
    }
}
