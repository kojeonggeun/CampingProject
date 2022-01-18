//
//  asdf.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/06.
//

import Foundation
import UIKit
import TextFieldEffects
import RxSwift
import RxCocoa
import simd

class GearDetailViewController: UIViewController {

    @IBOutlet weak var customView: GearTextListCustomView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var gearName: UILabel!
    @IBOutlet weak var gearType: UILabel!
    @IBOutlet weak var gearCompany: UILabel!
    @IBOutlet weak var gearColor: UILabel!
    @IBOutlet weak var gearPrice: UILabel!
    @IBOutlet weak var gearBuyDt: UILabel!
    
    
    
    var imageArray: [ImageData] = []
    var gearRow: Int = -1
    let apiService = APIManager.shared
    
    let userGearVM = UserGearViewModel.shared
    
    let DidDeleteGearPost: Notification.Name = Notification.Name("DidDeleteGearPost")
    let DidDeleteCatogoryGearPost: Notification.Name = Notification.Name("DidDeleteCatogoryGearPost")
    
    let disposeBag:DisposeBag = DisposeBag()
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        imageCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showDeleteAlert(_ sender: Any) {

        let id: Int = userGearVM.userGears[gearRow].id

        let alert = UIAlertController(title: nil, message: "장비를 삭제 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "삭제", style: .default) { action in
            self.userGearVM.deleteUserGear(gearId: id, row: self.gearRow)
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: self.DidDeleteGearPost, object: nil, userInfo: ["delete": true,"gearRow": self.gearRow])
            NotificationCenter.default.post(name: self.DidDeleteCatogoryGearPost, object: nil)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .default) { action in
            return
        })
        present(alert, animated: true)

    }
    @IBAction func gearEdit(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "GearEditView") as! GearEditViewController
        pushVC.gearRow = self.gearRow
        
        self.navigationController?.pushViewController(pushVC, animated: true)
        
    }
    
    
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadText()
        
        self.title = "장비 상세"
//        customView.UpdateData(type: type, name: name, color: color, company: company, capacity: capacity, buyDate: buyDt, price: price)
//        self.textFieldEdit(value: false)

        self.loadImage()

        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.red
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadImage), name: NSNotification.Name("DidReloadPostDetailViewController"), object: nil)
        
    }
    
  
    @objc func reloadImage(){
        self.imageArray.removeAll()
        self.loadText()
        self.loadImage()
    }
    
    func loadText(){
        let userData = userGearVM.userGears[gearRow]

        MyGearViewModel.shared.gearObservable
            .subscribe(onNext: { [weak self] result in
                self?.gearName.text = result[self!.gearRow].name!
                self?.gearType.text = "[\(result[self!.gearRow].gearTypeName!)]"
                self?.gearCompany.text = result[self!.gearRow].company!
                self?.gearColor.text = result[self!.gearRow].color
                self?.gearPrice.text = "\(result[self!.gearRow].price!)"
                self?.gearBuyDt.text = result[self!.gearRow].buyDt
                
                
            })
    }
    
    func loadImage() {
        
        UserViewModel.shared.loadGearDetailImagesRx(id:self.userGearVM.userGears[self.gearRow].id)
            .subscribe(onNext: { image in
                self.pageControl.numberOfPages = image.count
                self.pageControl.reloadInputViews()
                MyGearViewModel.shared.loadimage(image: image)
            }).disposed(by: disposeBag)
        
       MyGearViewModel.shared.gearImageObservable
           .bind(to: imageCollectionView.rx.items(cellIdentifier: "GearDetailViewCell",cellType: GearDetailViewCell.self)) { (row, element, cell) in
               cell.updateUI(item: element)
           }
    }
    
    func textFieldEdit(value: Bool) {
        let textFieldArr = [customView.gearType,customView.gearName,customView.gearColor,customView.gearCompany,customView.gearCapacity,customView.gearBuyDate,customView.gearPrice]
        for i in textFieldArr {
            i!.isUserInteractionEnabled = value
        }
        
    }
}

extension GearDetailViewController: UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width // 너비 저장
              let x = scrollView.contentOffset.x + (width / 2.0) // 현재 스크롤한 x좌표 저장
              
              let newPage = Int(x / width)
              if pageControl.currentPage != newPage {
                  pageControl.currentPage = newPage
              }
    }
}

extension GearDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
