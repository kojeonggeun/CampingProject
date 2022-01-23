//
//  CategoryTableViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/15.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class CategoryCollectionViewController: UIViewController {
      
    @IBOutlet var categoryCollectionView: UICollectionView!
    
    let gearTypeVM = GearTypeViewModel()
    let userGearVM = UserGearViewModel.shared
    
    let apiManager: APIManager = APIManager.shared
    let disposeBag = DisposeBag()
    
    var gearTypeNum: Int = 0
    var gearType: String = ""
    var tableIndex: IndexPath = []
   
  
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        gearType = gearTypeVM.gearTypes[gearTypeNum].gearName
        self.title = gearType
        userGearVM.categoryUserData(type: gearType)
        categoryCollectionView.register(UINib(nibName:String(describing: MyGearCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "myGearViewCell")
  
        categoryCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag
            )
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteTableCell(_:)), name: NSNotification.Name("DidDeleteCatogoryGearPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(_:)), name: NSNotification.Name("DidReloadPostEdit"), object: nil)
    }
    
    @objc func deleteTableCell(_ noti: Notification) {
        self.categoryCollectionView.performBatchUpdates({
            self.userGearVM.deleteCategoryData(row: tableIndex.row)
            self.categoryCollectionView.deleteItems(at: [self.tableIndex])
        }, completion: { (done) in
             //perform table refresh
        })
    
    }
    
    @objc func reloadTableView(_ noti: Notification){
        if noti.userInfo?["edit"] as! Bool{
            self.categoryCollectionView.reloadData()
        }
    }
    
    func loadData(){
        MyGearViewModel.shared.gearObservable
            .map {
                $0.filter { $0.gearTypeName == self.gearType}
            }
            .map{ $0.map { ViewGear($0) } }
            .bind(to: categoryCollectionView.rx.items(cellIdentifier: "myGearViewCell",cellType: MyGearCollectionViewCell.self)) { (row, element, cell) in
                UserViewModel.shared.loadGearImagesRx(id:element.id)
                    .subscribe(onNext: { image in
                        cell.collectionViewCellImage.image = image
                    }).disposed(by: self.disposeBag)
                cell.onData.onNext(element)
            }.disposed(by: disposeBag)
        
        categoryCollectionView.rx.modelSelected(CellData.self)
            .subscribe(onNext: { cell in
                print(cell.id)
            }).disposed(by: disposeBag)
        
        
        categoryCollectionView.rx.modelSelected(ViewGear.self)
            .subscribe(onNext: { cell in
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "GearDetailView") as! GearDetailViewController
                pushVC.gearId = cell.id
                self.navigationController?.pushViewController(pushVC, animated: true)
            })
    }
}

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
            let margin: CGFloat = 10
            let itemSpacing: CGFloat = 10
            
            let width = (collectionView.frame.width - margin * 2 - itemSpacing) / 2
            let height = width * 10/7.5

            return CGSize(width: width, height: height)
    }
}
