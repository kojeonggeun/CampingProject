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
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var segueText: String = ""
    var tableIndexPath = IndexPath()
    
    
    var tableData = [TableViewCellData]()
    
    let gearTypeVM = GearTypeViewModel()
    let userGearVM = UserGearViewModel()
    let tableViewVM = TableViewViewModel()
    let apiManager: APIManager = APIManager.shared
    
    
    
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
            
            guard let data = sender as? NSArray else { return }
            vc.gearSection = data[0] as! Int
            vc.gearRow = data[1] as! Int
            
        }
    }
    
    func loadData(){
        apiManager.loadUserData( completion: { userData in
            DispatchQueue.global().async {
                self.apiManager.loadGearType(completion: { data in
                    for i in 0..<self.gearTypeVM.gearTypes.count{
                        self.apiManager.loadTableViewData(tableData: TableViewCellData(isOpened: false, gearTypeName: self.gearTypeVM.gearTypes[i].gearName))
                        
                        for j in self.userGearVM.userGears{
                            
                            if self.gearTypeVM.gearTypes[i].gearName == j.gearTypeName{
                                
                                self.apiManager.tableViewData[i].update(id: j.id, name: j.name ?? "")        
                            }// end if
                        }
                    }// end first for
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.categoryCollectionView.reloadData()
                        
                    }
                })
            } // end global.async
        })
        
    }
    
    @objc func reloadTableView(_ noti: Notification) {
        if let gearId = noti.userInfo?["gearAddId"] as? Int {
            guard let first = self.gearTypeVM.gearTypes.firstIndex(where: { $0.gearID == gearId}) else { return }
                DispatchQueue.global().async {
                    self.apiManager.loadUserData(completion: { data in
                        if data {
                            let gearEndIndex = self.apiManager.userGears.endIndex - 1
                            self.apiManager.tableViewData[first].update(id: self.userGearVM.userGears[gearEndIndex].id, name: self.userGearVM.userGears[gearEndIndex].name ?? "")

                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })// end closure
                }
        }
        
        if noti.userInfo?["delete"] as? Bool ?? false {
            self.tableView.performBatchUpdates({
                
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userGearVM.userGears.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FirstViewCell", for: indexPath) as? MyGearViewCell else { return UITableViewCell() }
        
        apiManager.loadGearImages(gearId: self.userGearVM.userGears[indexPath.row].id, completion: { data in
            DispatchQueue.global().async {
                if !data.isEmpty {
                    let url = URL(string: data[0].url) ?? URL(string: "awd")
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        let image = UIImage(data: data!)
                        cell.tableViewCellImage.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        let image = UIImage(systemName: "camera.circle")
                        image?.withTintColor(UIColor.lightGray)
                        cell.tableViewCellImage.image = image
                    }
                }
            }
        })

        cell.tableViewCellText.text = self.userGearVM.userGears[indexPath.row].name
        cell.tableViewCellGearType.text = self.userGearVM.userGears[indexPath.row].gearTypeName
        
        return cell
    }

    
//    밀어서 삭제하기
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            
            self.userGearVM.deleteUserGear(gearId: self.userGearVM.userGears[indexPath.row].id,row: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            DispatchQueue.main.async {
                self.tableView.reloadSections([indexPath.section], with: .automatic)
            }
            completion(true)
        }
                
                action.backgroundColor = .red
                action.title = "삭제"
                let configuration = UISwipeActionsConfiguration(actions: [action])
                configuration.performsFirstActionWithFullSwipe = false
                return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


extension MyGearViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        let first = self.userGearVM.userGears.firstIndex(where: { $0.id == self.userGearVM.userGears[indexPath.row].id})
        
        tableIndexPath = indexPath
        let data = [indexPath.section,indexPath.row]
        self.performSegue(withIdentifier: "GearDetailViewController", sender: data)
            
    }
}
   

extension MyGearViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return gearTypeVM.GearTypeNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        
        cell.updateUI(title: gearTypeVM.gearTypes[indexPath.row].gearName)
        
        return cell
    }
    
    
}

extension MyGearViewController: UICollectionViewDelegate {
    
}

extension MyGearViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//
//    }
 
}
