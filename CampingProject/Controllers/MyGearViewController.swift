//  First.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/07.

import UIKit
import RxSwift
import RxCocoa
class MyGearViewController: UIViewController{
    @IBOutlet weak var myGearCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
        
    var segueText: String = ""
    var collectionIndexPath = IndexPath()
    
    let gearTypeVM = GearTypeViewModel()
    let userGearVM = UserGearViewModel.shared
    let apiManager: APIManager = APIManager.shared
    let myGearVM: MyGearViewModel = MyGearViewModel.shared
    var disposeBag:DisposeBag = DisposeBag()
    

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
        

        let config = UIImage.SymbolConfiguration(scale: .small)
        navigationController?.tabBarItem.image = UIImage(systemName: "house.fill", withConfiguration: config)
        myGearCollectionView.register(UINib(nibName:String(describing: MyGearCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier:MyGearCollectionViewCell.identifier )
        
        self.loadData()

        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(_:)), name: NSNotification.Name("DidDeleteGearPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(_:)), name: NSNotification.Name("DidReloadPostEdit"), object: nil)
        
        
        
    } // end viewDidLoad
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

    func loadData(){
        
        myGearVM.loadGears()
        
        myGearVM.gearObservable
            .map{ $0.map { ViewGear($0) } }
            .bind(to: myGearCollectionView.rx.items(cellIdentifier: MyGearCollectionViewCell.identifier,cellType: MyGearCollectionViewCell.self)) { (row, element, cell) in
                cell.onData.onNext(element)
                
            }.disposed(by: disposeBag)
            
        myGearVM.gearTypeObservable
            .bind(to: categoryCollectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.identifier, cellType: CategoryCollectionViewCell.self)) { (row, element, cell) in
                
                cell.categoryButton.rx.tap.asDriver()
                    .drive(onNext: { [weak self] in
                        let pushVC = self?.storyboard?.instantiateViewController(withIdentifier: CategoryCollectionViewController.identifier) as! CategoryCollectionViewController
                            pushVC.gearTypeNum = row
                        self?.navigationController?.pushViewController(pushVC, animated: true)
                        
                    }).disposed(by: cell.disposeBag)
                cell.updateUI(title: element.gearName)
            }.disposed(by: disposeBag)

        myGearCollectionView.rx.modelSelected(ViewGear.self)
            .subscribe(onNext: { cell in
                
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: GearDetailViewController.identifier) as! GearDetailViewController
                pushVC.gearId = cell.id
                self.navigationController?.pushViewController(pushVC, animated: true)
                
            }).disposed(by: disposeBag)
    }

    @objc func reloadTableView(_ noti: Notification) {

        var CategoryIndexPath: IndexPath = []
        
        if let row =  noti.userInfo?["gearRow"] as? Int {
            if row != -1 {
                CategoryIndexPath = [0, row]
            } else {
                CategoryIndexPath = self.collectionIndexPath
            }
        }

        if noti.userInfo?["delete"] as? Bool ?? false {
            self.myGearCollectionView.performBatchUpdates({
                self.myGearCollectionView.deleteItems(at:[CategoryIndexPath])
            }, completion: { (done) in
                 //perform table refresh
            })
        }
        
        if noti.userInfo?["edit"] as? Bool ?? false {
            self.myGearCollectionView.reloadData()
        }
    }
  
    
}


extension MyGearViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //      카테고리 적용 시 필요
                let first = self.userGearVM.userGears.firstIndex(where: { $0.id == self.userGearVM.userGears[indexPath.row].id})!
                collectionIndexPath = indexPath
                
    }
}

extension MyGearViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == myGearCollectionView {
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
