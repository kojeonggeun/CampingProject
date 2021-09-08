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
    
    var segueText: String = ""
    var tableIndexPath = IndexPath()
    
    @IBAction func unwind(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        
        performSegue(withIdentifier: "unwindVC1", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailText.text = segueText
        tableView.showsVerticalScrollIndicator = false
        
      
            
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(_:)), name: NSNotification.Name("DidReloadPostMyGearViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(_:)), name: NSNotification.Name("DidDeleteGearPost"), object: nil)
        
    } // end viewDidLoad
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GearDetailViewController"{
            let vc = segue.destination as! GearDetailViewController
            vc.gearIndex = sender as! Int
        }
    }
    
    func loadData(){
        gearManager.loadUserData( completion: { userData in
            DispatchQueue.global().async {
                self.gearManager.loadGearType(completion: { data in
                    for i in 0..<data.count{
                        self.tableViewData.append(TableViewCellData(isOpened: false, gearTypeName: data[i].gearName))

                        for j in self.gearManager.userGear{
                            if data[i].gearName == j.gearTypeName{
                                self.tableViewData[i].update(id: j.id, name: j.name ?? "")
                            }// end if
                        }
                    }// end first for
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            } // end global.async
        })
    }
    
    @objc func reloadTableView(_ noti: Notification) {
        if let gearId = noti.userInfo?["gearAddId"] as? Int {
            guard let first = gearManager.gearTypes.firstIndex(where: { $0.gearID == gearId}) else { return }
                DispatchQueue.global().async {
                    self.gearManager.loadUserData(completion: { data in
                        if data {
                            let gearEndIndex = self.gearManager.userGear.endIndex - 1
                            self.tableViewData[first].update(id: self.gearManager.userGear[gearEndIndex].id, name: self.gearManager.userGear[gearEndIndex].name ?? "")

                            DispatchQueue.main.async {
                                self.tableView.reloadSections(IndexSet([first]), with: .automatic)
                            }
                        }
                    })// end closure
                }
        }
        
        if noti.userInfo?["delete"] as? Bool ?? false {
            self.tableView.performBatchUpdates({
                 //do stuff then delete the row
                self.tableViewData[self.tableIndexPath.section].name.remove(at: self.tableIndexPath.row)
                self.tableView.deleteRows(at: [self.tableIndexPath], with: .fade)
            }, completion: { (done) in
                 //perform table refresh
                self.tableView.reloadSections([self.tableIndexPath.section], with: .automatic)
            })
        }
    }
  
    
}// end FirstViewController



extension MyGearViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return gearManager.GearTypeNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableViewData[section].isOpened == true {
            return tableViewData[section].name.count
        }
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
                self.tableViewData[indexPath.section].name.remove(at: indexPath.row)
                   tableView.deleteRows(at: [indexPath], with: .automatic)
                    completion(true)
                }
                
                action.backgroundColor = .blue
                

                let configuration = UISwipeActionsConfiguration(actions: [action])
                configuration.performsFirstActionWithFullSwipe = false
                return configuration
    }
}

extension MyGearViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if let first = gearManager.userGear.firstIndex(where: { $0.id == tableViewData[indexPath.section].gearId[indexPath.row]})
        {
            tableIndexPath = indexPath
            self.performSegue(withIdentifier: "GearDetailViewController", sender: first)
            
        } else {
            return
        }
    }
}
   






