//
//  First.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/07.
//

import UIKit


class MyGearViewController: UIViewController{
    
  
    @IBOutlet weak var gearTableView: UITableView!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    
    var segueText: String = ""
    var tableIndexPath = IndexPath()
    
    let gearTypeVM = GearTypeViewModel()
    let userGearVM = UserGearViewModel()
    let tableViewVM = TableViewViewModel()
    let apiManager: APIManager = APIManager.shared
    
    
    
    @IBAction func addGearMove(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AddGearView")
        self.navigationController?.pushViewController(pushVC!, animated: true)
        
    }
    @IBAction func unwind(_ sender: Any) {
        DB.userDefaults.removeObject(forKey: "token")
        DB.userDefaults.set(false, forKey: "Auto")
        
        performSegue(withIdentifier: "unwindVC1", sender: self)
    }
    
  // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.prefersLargeTitles = true
//
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = .lightGray
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        emailText.text = segueText
        gearTableView.showsVerticalScrollIndicator = false
        
        self.loadData()

        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(_:)), name: NSNotification.Name("DidReloadPostMyGearViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(_:)), name: NSNotification.Name("DidDeleteGearPost"), object: nil)
        
    } // end viewDidLoad
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

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
                        self.gearTableView.reloadData()
                        self.categoryCollectionView.reloadData()
                        
                    }
                })
            } // end global.async
        })
        
    }
    
    @objc func reloadTableView(_ noti: Notification) {
        if (noti.userInfo?["gearAddId"] as? Int) != nil {
//            guard let first = self.gearTypeVM.gearTypes.firstIndex(where: { $0.gearID == gearId}) else { return }
                DispatchQueue.global().async {
                    self.apiManager.loadUserData(completion: { data in
                        if data {
//                            let gearEndIndex = self.apiManager.userGears.endIndex - 1
//                            self.apiManager.tableViewData[first].update(id: self.userGearVM.userGears[gearEndIndex].id, name: self.userGearVM.userGears[gearEndIndex].name ?? "")

                            DispatchQueue.main.async {
                                self.gearTableView.reloadData()
                                
                            }
                        }
                    })// end closure
                }
        }
        
        if noti.userInfo?["delete"] as? Bool ?? false {
            self.gearTableView.performBatchUpdates({
                
                self.gearTableView.deleteRows(at: [self.tableIndexPath], with: .fade)
            }, completion: { (done) in
                 //perform table refresh
                self.gearTableView.reloadSections([self.tableIndexPath.section], with: .automatic)
            })
        }
    }
  
    
}// end FirstViewController


// TableView
extension MyGearViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userGearVM.userGears.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FirstViewCell", for: indexPath) as? MyGearViewCell else { return UITableViewCell() }
        
        let userGearId = self.userGearVM.userGears[indexPath.row].id
        
        if let cacheImage = self.apiManager.imageCache.image(withIdentifier: "\(userGearId)") {
            DispatchQueue.main.async {
                cell.tableViewCellImage.image = cacheImage
            }
            
        } else {
            apiManager.loadGearImages(gearId: userGearId, completion: { data in
                DispatchQueue.global().async {
                    if !data.isEmpty {
                        let url = URL(string: data[0].url)
//                        let url = URL(string: "https://doodleipsum.com/600?shape=circle&bg=ceebff")
                        let data = try? Data(contentsOf: url!)
                        let image = UIImage(data: data!)
                        DispatchQueue.main.async {
                            cell.tableViewCellImage.image = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.tableViewCellImage.image = self.apiManager.imageCache.image(withIdentifier: "\(userGearId)")!
                        }
                    }
                }
            })
        }
        if let gearName = self.userGearVM.userGears[indexPath.row].name,
           let gearType = self.userGearVM.userGears[indexPath.row].gearTypeName,
           let gearDate = self.userGearVM.userGears[indexPath.row].buyDt {
            cell.updateUI(name: gearName, type: gearType, date: gearDate)
        }
        
        return cell
    }

    
//    밀어서 삭제하기
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let first = self.userGearVM.userGears.firstIndex(where: { $0.id == self.userGearVM.userGears[indexPath.row].id})!
        
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            
            self.userGearVM.deleteUserGear(gearId: self.userGearVM.userGears[indexPath.row].id,row: indexPath.row)
            self.gearTableView.deleteRows(at: [indexPath], with: .automatic)
            
            DispatchQueue.main.async {
                self.gearTableView.reloadData()
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
//      카테고리 적용 시 필요
        let first = self.userGearVM.userGears.firstIndex(where: { $0.id == self.userGearVM.userGears[indexPath.row].id})!

        tableIndexPath = indexPath
//        let data = [indexPath.section,indexPath.row]
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "GearDetailView") as! GearDetailViewController
        
        pushVC.gearRow = first
        self.navigationController?.pushViewController(pushVC, animated: true)

            
    }
}
   
// CollectionView
extension MyGearViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gearTypeVM.GearTypeNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        
        
        cell.categoryButton.tag = indexPath.row
        cell.categoryButton.addTarget(self, action: #selector(categoryClicked), for: .touchUpInside)
        cell.updateUI(title: gearTypeVM.gearTypes[indexPath.row].gearName)
        
        return cell
    }
    
//    카테고리를 누르면 해당하는 User데이터를 가지고 tableView를 reload??
    @objc func categoryClicked(_ sender: UIButton){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryTableView") as! CategoryTableViewController
        pushVC.gearType = sender.tag
        
        self.navigationController?.pushViewController(pushVC, animated: true)
        
    }
}

extension MyGearViewController: UICollectionViewDelegate {
  
}
