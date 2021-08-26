//
//  First.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/07.
//

import UIKit

class MyGearViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailText: UILabel!
    
    
    @IBAction func unwind(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        
        performSegue(withIdentifier: "unwindVC1", sender: self)
    }
    
    var gearManager: GearManager = GearManager.shared
    
    
    var tableViewData = [TableViewCellData]()
    var gearType = [GearType]()
    var tableData = [CellData]()

    var segueText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailText.text = segueText
        
        gearManager.loadUserData(completion: { data in
            if data {
                
                DispatchQueue.main.async {
                    self.gearManager.loadGearType(completion: { data in
                        self.gearType = data
                        for i in 0..<self.gearType.count{
                            self.tableViewData.append(TableViewCellData(isOpened: false, gearTypeName: self.gearType[i].gearName))
                            
                            for j in self.gearManager.userGear{
                                if self.gearType[i].gearName == j.gearTypeName{
                                  
                                    self.tableViewData[i].update(name: j.name)  
                                }
                            }
                        }
                        self.tableView.reloadData()
                    })
                } // end main.async
                
            } else {
                print("data Empty")
            }
        })
        

        
   
    } // end viewDidLoad
}// end FirstViewController

extension MyGearViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return gearType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableViewData[section].isOpened == true {
            // tableView Section이 true면 title + sectionData 개수만큼 추가
            return tableViewData[section].name.count + 1 }
        else {
            // tableView Section이 false면 title 한개만 리턴
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FirstViewCell", for: indexPath) as? MyGearViewCell else { return UITableViewCell() }
            cell.tableViewCellText.text = tableViewData[indexPath.section].gearTypeName
            cell.expandButton.isHidden = false
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FirstViewCell", for: indexPath) as? MyGearViewCell else { return UITableViewCell() }
//            cell.tableViewCellText.text = tableViewData[indexPath.section].name[indexPath.row - 1]
        
            cell.tableViewCellText.text = tableViewData[indexPath.section].name[indexPath.row - 1]
            if indexPath.row != 0{
                cell.backgroundColor = .white
                cell.expandButton.isHidden = true
            }
            return cell
        }
    }
    
}

extension MyGearViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            tableViewData[indexPath.section].isOpened = !tableViewData[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
            
        } else {
            
            print(indexPath)
            
        }
    }
}


