//
//  DetailCollectionViewViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DetailCollectionViewViewController: UIViewController{
    
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    let disposeBag = DisposeBag()
    let userGearVM = UserGearViewModel.shared
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        detailCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    func setupBinding(){
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.red
            
        
        UserViewModel.shared.loadGearDetailImagesRx(id:self.userGearVM.userGears[16].id)
            .subscribe(onNext: { image in
                self.pageControl.numberOfPages = image.count
                self.pageControl.reloadInputViews()
                MyGearViewModel.shared.loadimage(image: image)
            }).disposed(by: disposeBag)
        
       MyGearViewModel.shared.gearImageObservable
           .bind(to: detailCollectionView.rx.items(cellIdentifier: "GearDetailViewCell",cellType: GearDetailCollectionViewCell.self)) { (row, element, cell) in
               cell.updateUI(item: element)
           }
    }
}


extension DetailCollectionViewViewController: UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width // 너비 저장
              let x = scrollView.contentOffset.x + (width / 2.0) // 현재 스크롤한 x좌표 저장
              
              let newPage = Int(x / width)
              if pageControl.currentPage != newPage {
                  pageControl.currentPage = newPage
              }
    }
}

extension DetailCollectionViewViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
