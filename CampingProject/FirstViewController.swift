//
//  First.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/07.
//

import UIKit

class FirstViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailText: UILabel!
    
    
    @IBAction func unwind(_ sender: Any) {
        performSegue(withIdentifier: "unwindVC1", sender: self)
    }
    
    let userManager: UserManager = UserManager.shared
    
    let category: [String] = ["텐트","타프", "의자","테이블","침낭","매트","랜턴","코펠","식기","버너","난방","가스","배낭","의류","캠핑 악세서리"]
    var tableViewData = [TableViewCellData]()
    
    var tableData = [CellData]()
    
    var segueText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        GearManager.shared.loadGearType()

        
        for i in category{
            tableViewData.append(TableViewCellData(opened: false, gearTypeName: i, name: "우드테이블"))
        }
        emailText.text = segueText
        
        
        userManager.loadUserData(completion: { data in
            self.tableData = data
//            for i in self.category{
//
//                self.tableViewData.append(TableViewCellData(opened: false, gearTypeName: i, name: "없음" ))
//            
//            }
//            print(self.tableViewData)
        })
    }
  
}

extension FirstViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            // tableView Section이 true면 title + sectionData 개수만큼 추가
            return tableViewData[section].name.count + 1 }
        else {
            // tableView Section이 false면 title 한개만 리턴
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FirstViewCell", for: indexPath) as? FirstViewCell else { return UITableViewCell() }
            cell.tableViewCellText.text = tableViewData[indexPath.section].gearTypeName
            cell.expandButton.isHidden = false
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FirstViewCell", for: indexPath) as? FirstViewCell else { return UITableViewCell() }
//            cell.tableViewCellText.text = tableViewData[indexPath.section].name[indexPath.row - 1]
            cell.tableViewCellText.text = tableViewData[indexPath.section].name
            if indexPath.row != 0{
                cell.backgroundColor = .white
                cell.expandButton.isHidden = true
            }
            return cell
        }
    }
    
}

extension FirstViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            tableViewData[indexPath.section].opened = !tableViewData[indexPath.section].opened
            tableView.reloadSections([indexPath.section], with: .none)
            
        } else {
            print(indexPath)
            test()
        }
    }
    
    func test(){
        print("Test")
    }
}

