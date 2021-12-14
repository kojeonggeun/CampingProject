//
//  First.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/07.
//

import UIKit


class MyGearViewController: UIViewController{
    
  
    @IBOutlet weak var myGearCollectionVIew: UICollectionView!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    
    var segueText: String = ""
    var collectionIndexPath = IndexPath()
    
    let gearTypeVM = GearTypeViewModel()
    let userGearVM = UserGearViewModel.shared
    
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
        
        
        
        
        myGearCollectionVIew.register(UINib(nibName:String(describing: MyGearCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "myGearViewCell")
        
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(_:)), name: NSNotification.Name("DidReloadPostMyGearViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(_:)), name: NSNotification.Name("DidDeleteGearPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(_:)), name: NSNotification.Name("DidReloadPostEdit"), object: nil)
        
        
        
    } // end viewDidLoad
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    func loadData(){
        apiManager.loadUserGear( completion: { userData in

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
                        self.myGearCollectionVIew.reloadData()
                        self.categoryCollectionView.reloadData()
                    }
                })
            } // end global.async
        })
        
    }

    @objc func reloadTableView(_ noti: Notification) {
        if (noti.userInfo?["gearAddId"] as? Int) != nil {
                DispatchQueue.global().async {
                    self.apiManager.loadUserGear(completion: { data in
                        if data {
                            DispatchQueue.main.async {
                                self.myGearCollectionVIew.reloadData()
                            }
                        }
                    })// end closure
                }
        }
        
//      카테고리에서 삭제할 때 인덱스값과 메인에서 삭제할 때 인덱스 값이 상이함
//      카테고리에서 삭제할 때 메인의 인덱스값을 가져오게 함, 메인과 카테고리에서 동시에 리스트에서 삭제되게
//      코드가 너무 지저분해서 리팩토링 필수
        
        var CategoryIndexPath: IndexPath = []
        if let row =  noti.userInfo?["gearRow"] as? Int {
            if row != -1 {
                CategoryIndexPath = [0, row]
            } else {
                CategoryIndexPath = self.collectionIndexPath
            }
        }

        if noti.userInfo?["delete"] as? Bool ?? false {
            self.myGearCollectionVIew.performBatchUpdates({
                self.myGearCollectionVIew.deleteItems(at:[CategoryIndexPath])
            }, completion: { (done) in
                 //perform table refresh
            })
        }
        
        if noti.userInfo?["edit"] as? Bool ?? false {
            self.myGearCollectionVIew.reloadData()
        }
        
   
    }
  
    
}// end FirstViewController


extension MyGearViewController: UICollectionViewDataSource{
   
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return gearTypeVM.GearTypeNumberOfSections()
        }
        
        return self.userGearVM.userGears.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
    
    
            cell.categoryButton.tag = indexPath.row
            cell.categoryButton.addTarget(self, action: #selector(categoryClicked), for: .touchUpInside)
            cell.updateUI(title: gearTypeVM.gearTypes[indexPath.row].gearName)
    
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myGearViewCell", for: indexPath) as? MyGearCollectionViewCell else { return UICollectionViewCell() }
        
        let userGearId = self.userGearVM.userGears[indexPath.row].id
        
        if let cacheImage = self.apiManager.imageCache.image(withIdentifier: "\(userGearId)") {
            DispatchQueue.main.async {
                cell.collectionViewCellImage.image = cacheImage
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
                            cell.collectionViewCellImage.image = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.collectionViewCellImage.image = self.apiManager.imageCache.image(withIdentifier: "\(userGearId)")!
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
    
    @objc func categoryClicked(_ sender: UIButton){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryCollectionView") as! CategoryCollectionViewController

        pushVC.gearType = sender.tag
        self.navigationController?.pushViewController(pushVC, animated: true)


    }
    
////    밀어서 삭제하기
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
////        let first = self.userGearVM.userGears.firstIndex(where: { $0.id == self.userGearVM.userGears[indexPath.row].id})!
//
//        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
//
//            self.userGearVM.deleteUserGear(gearId: self.userGearVM.userGears[indexPath.row].id,row: indexPath.row)
//            self.gearTableView.deleteRows(at: [indexPath], with: .automatic)
//
//            DispatchQueue.main.async {
//                self.gearTableView.reloadData()
//            }
//            completion(true)
//        }
//
//                action.backgroundColor = .red
//                action.title = "삭제"
//                let configuration = UISwipeActionsConfiguration(actions: [action])
//                configuration.performsFirstActionWithFullSwipe = false
//                return configuration
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//}
}

extension MyGearViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //      카테고리 적용 시 필요
                let first = self.userGearVM.userGears.firstIndex(where: { $0.id == self.userGearVM.userGears[indexPath.row].id})!

                collectionIndexPath = indexPath
        //        let data = [indexPath.section,indexPath.row]
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "GearDetailView") as! GearDetailViewController
                
                pushVC.tableIndex = indexPath
                pushVC.gearRow = first
                self.navigationController?.pushViewController(pushVC, animated: true)
    }
   
}
   
extension MyGearViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == myGearCollectionVIew {
            let margin: CGFloat = 10
            let itemSpacing: CGFloat = 10
            
            let width = (collectionView.frame.width - margin * 2 - itemSpacing) / 2
            let height = width * 10/7.5

            return CGSize(width: width, height: height)
        
        }
        let width = collectionView.bounds.width / 4
        let height = collectionView.bounds.height / 1.7
        
        return CGSize(width: width, height: height)
    }
}
