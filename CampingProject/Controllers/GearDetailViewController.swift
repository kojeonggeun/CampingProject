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
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var gearDetailCollectionView: UICollectionView!
    
    static let identifier: String = "GearDetailViewController"
    var gearId: Int = -1
    var userId: Int = 0
    
    let apiManager = APIManager.shared
    
    let userGearVM = UserGearViewModel.shared
    let store = Store.shared
    let DidDeleteGearPost: Notification.Name = Notification.Name("DidDeleteGearPost")
    let DidDeleteCatogoryGearPost: Notification.Name = Notification.Name("DidDeleteCatogoryGearPost")
    
    let disposeBag:DisposeBag = DisposeBag()
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        gearDetailCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "장비 상세"
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.red
              
  
        
        requestData()
    }
    
    @IBAction func showDeleteAlert(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: "장비를 삭제 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "삭제", style: .default) { action in
            self.userGearVM.deleteUserGear(gearId: self.gearId)
            
            self.navigationController?.popViewController(animated: true)
            
        })
        alert.addAction(UIAlertAction(title: "취소", style: .default) { action in
            return
        })
        present(alert, animated: true)

    }
    @IBAction func gearEdit(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "GearEditView") as! GearEditViewController
        pushVC.gearId = self.gearId
        pushVC.userId = self.userId
        
        self.navigationController?.pushViewController(pushVC, animated: true)

    }
    
    func requestData() {
 
//        GearDetailViewModel.shared.gearDetail
//            .map { $0.images }
//            .do{
//                self.pageControl.numberOfPages = $0.count
//                self.pageControl.reloadInputViews()
//            }
//            .bind(to:gearDetailCollectionView.rx.items(cellIdentifier: GearDetailImageCollectionViewCell.identifier, cellType: GearDetailImageCollectionViewCell.self)) { (row, element, cell) in
//                cell.onData.onNext(element)
//            }.disposed(by: disposeBag)
          
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
