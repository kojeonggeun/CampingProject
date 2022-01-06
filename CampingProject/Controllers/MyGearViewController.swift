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
    var myGear: [MyGearRepresentable] = []
    
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
        ProfileViewModel.shared.clearUserCount()

        performSegue(withIdentifier: "unwindVC1", sender: self)
    }
  
  // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self)
            
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.topItem?.title = "테스트"
//
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
    
        let config = UIImage.SymbolConfiguration(scale: .small)
        navigationController?.tabBarItem.image = UIImage(systemName: "house.fill", withConfiguration: config)
        
        
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
  
    
}
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
        
        print(myGear[indexPath.row].myGear.name)
        
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
