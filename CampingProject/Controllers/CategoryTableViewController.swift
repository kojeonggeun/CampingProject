//
//  CategoryTableViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/15.
//

import Foundation
import UIKit



class CategoryTableViewController: UITableViewController{
    
    let gearTypeVM = GearTypeViewModel()
    let userGearVM = UserGearViewModel()
    let tableViewVM = TableViewViewModel()
    let apiManager: APIManager = APIManager.shared
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userGearVM.userGears.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        
        let userGearId = self.userGearVM.userGears[indexPath.row].id
        
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
        
        if let gearName = self.userGearVM.userGears[indexPath.row].name,
           let gearType = self.userGearVM.userGears[indexPath.row].gearTypeName {
            cell.updateUI(name: gearName, type: gearType)
        }
        
        return cell
    }
}



