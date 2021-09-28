//
//  asdf.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/06.
//

import Foundation
import UIKit
import TextFieldEffects

class GearDetailViewController: UIViewController {

    @IBOutlet weak var customView: GearTextListCustomView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
 
    @IBOutlet weak var pageControl: UIPageControl!
    
    var gearRow = Int()
    var imageArray = [ImageData]()
    let apiService = APIManager.shared
    
    let userGearVM = UserGearViewModel()
    
    let DidDeleteGearPost: Notification.Name = Notification.Name("DidDeleteGearPost")
    
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
            self.userGearVM.deleteUserGear(gearId: id, row: self.gearRow )
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: self.DidDeleteGearPost, object: nil, userInfo: ["delete": true])
            
        })
        alert.addAction(UIAlertAction(title: "취소", style: .default) { action in
            return
        })
        present(alert, animated: true, completion: nil)

    }
    @IBAction func gearEdit(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "GearEditView") as! GearEditViewController
        pushVC.gearRow = gearRow
        
        self.navigationController?.pushViewController(pushVC, animated: true)
        
    }
    
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userData = userGearVM.userGears[gearRow]
   
        self.title = "장비 상세"
        
//        guard let type = userData.gearTypeName else { return }
//        guard let name = userData.name else { return }
//        guard let color = userData.color else { return }
//        guard let company = userData.company else { return }
//        guard let capacity = userData.capacity else { return }
//        guard let buyDt = userData.buyDt else { return  }
//        guard let price = userData.price else { return }
        
//        customView.UpdateDate(type: type, name: name, color: color, company: company, capacity: capacity, buyDate: buyDt, price: price)
        
//        self.textFieldEdit(value: false)

        apiService.loadGearImages(gearId: userData.id, completion: { data in
            for i in data {
                self.imageArray.append(i)
            }
            self.pageControl.numberOfPages = self.imageArray.count
            self.imageCollectionView.reloadData()
            
        })
        
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.red
        print(userData)
    }
    
    func textFieldEdit(value: Bool) {
        let textFieldArr = [customView.gearType,customView.gearName,customView.gearColor,customView.gearCompany,customView.gearCapacity,customView.gearBuyDate,customView.gearPrice]
        for i in textFieldArr {
            i!.isUserInteractionEnabled = value
        }
        
    }
}

extension GearDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GearDetailViewCell", for: indexPath) as? GearDetailViewCell else { return UICollectionViewCell() }
        
       
        DispatchQueue.global().async {
            let url = URL(string: self.imageArray[indexPath.row].url)
            let data = try? Data(contentsOf: url!)

            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                cell.updateUI(item: image)
                }
            }
        
        return cell
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
