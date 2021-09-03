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
    
    
    var gearManager: GearManager = GearManager.shared
    var tableViewData = [TableViewCellData]()
    var gearType = [GearType]()
    var segueText: String = ""
    
    @IBAction func unwind(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        
        performSegue(withIdentifier: "unwindVC1", sender: self)
    }
    
    @IBAction func addGear(_ sender: Any) {
        
        performSegue(withIdentifier: "AddGearViewController", sender: tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailText.text = segueText
        tableView.showsVerticalScrollIndicator = false
        
        gearManager.loadUserData(completion: { data in
            if data {
                
                DispatchQueue.global().async {
                    self.gearManager.loadGearType(completion: { data in
                        self.gearType = data
                        for i in 0..<self.gearType.count{
                            self.tableViewData.append(TableViewCellData(isOpened: false, gearTypeName: self.gearType[i].gearName))
                            
                            for j in self.gearManager.userGear{
                                if self.gearType[i].gearName == j.gearTypeName{
                                    self.tableViewData[i].update(id: j.id, name: j.name)
                                }// end if
                            }
                        }// end first for
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    })
                } // end global.async
                
            } else {
                print("data Empty")
            }
        })
        NotificationCenter.default.addObserver(self, selector: #selector(self.DidDismissPost(_:)), name: NSNotification.Name("DidDismissPostMyGearViewController"), object: nil)
        
    } // end viewDidLoad
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GearDetailViewController"{
            let vc = segue.destination as! GearDetailViewController
            vc.gearIndex = sender as! Int
        }

    }
    @objc func DidDismissPost(_ noti: Notification) {
// self.tableViewData에 데이터 추가 해야 함
//  데이터세이브할때 구조 변경 필요
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}// end FirstViewController

extension MyGearViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return gearType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableViewData[section].isOpened == true {
            
            return tableViewData[section].name.count}
        else {
            
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        let item = tableViewData[section].gearTypeName
        let itemCount = tableViewData[section].name.count
        
        button.setTitle("\(item) (\(itemCount)) 보유 중", for: .normal)
        button.addTarget(self, action: #selector(clicked), for: .touchUpInside)
        button.tintColor = .white
        
        button.titleLabel?.font = UIFont.systemFont(ofSize:15, weight: .bold)
        
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 8

        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets.left = 20

        button.tag = section
        
        return button
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
        footerView.backgroundColor = UIColor.clear
        return footerView

    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        10
    }
  
    
    @objc func clicked(_ sender: UIButton){
        let row = sender.tag
        tableViewData[row].isOpened = !tableViewData[row].isOpened
        tableView.reloadSections([row], with: .automatic)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FirstViewCell", for: indexPath) as? MyGearViewCell else { return UITableViewCell()}
        
        cell.tableViewCellText.text = tableViewData[indexPath.section].name[indexPath.row]
        
        
        return cell
    }
}

extension MyGearViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        if let first = gearManager.userGear.firstIndex(where: { $0.id == tableViewData[indexPath.section].gearId[indexPath.row]})
        {
            
            self.performSegue(withIdentifier: "GearDetailViewController", sender: first)
        } else {
            return
        }
        
        }
    }
   






