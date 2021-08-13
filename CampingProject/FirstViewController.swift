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
    
    let category: [String] = ["텐트/타프", "의자/테이블","침낭/매트","랜턴","코펠/식기","버너/난로/난방","가스/연료","배낭","의류","캠핑 악세서리"]
    var tableViewData = [cellData]()
    var segueText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in category{
            tableViewData.append(cellData(opened: false, title: i, sectionData: ["Cell1", "Cell2", "Cell3"]))
        }
        emailText.text = segueText
    }

  
}

extension FirstViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            // tableView Section이 열려있으면 Section Cell 하나에 sectionData 개수만큼 추가해줘야 함
            return tableViewData[section].sectionData.count + 1 }
        else {
            // tableView Section이 닫혀있을 경우에는 Section Cell 하나만 보여주면 됨
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FirstViewCell", for: indexPath) as? FirstViewCell else { return UITableViewCell() }
            cell.tableViewCellText.text = tableViewData[indexPath.section].title
//            cell.backgroundColor = .purple
            cell.expandButton.isHidden = false
            cell.expandButton.isSelected = true
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FirstViewCell", for: indexPath) as? FirstViewCell else { return UITableViewCell() }
            cell.tableViewCellText.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            
            if indexPath.row != 0{
                cell.backgroundColor = .white
                cell.expandButton.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            tableViewData[indexPath.section].opened = !tableViewData[indexPath.section].opened
            tableView.reloadSections([indexPath.section], with: .none)
            
        } else {
            print("이건 sectionData 선택한 거야")
            test()
        }
        
        print([indexPath.section], [indexPath.row])

        
    }
    
    
}

extension FirstViewController: UITableViewDelegate{
    
    func test(){
        print("Test")
    }
}

