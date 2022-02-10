//  First.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/07.

import UIKit
import RxSwift
import RxCocoa
class MyGearViewController: UIViewController{
    var collectionIndexPath = IndexPath()
    
    var viewModel: MyGearViewModel!
    var disposeBag:DisposeBag = DisposeBag()
    
    init(viewModel: MyGearViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
 
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let config = UIImage.SymbolConfiguration(scale: .small)
        navigationController?.tabBarItem.image = UIImage(systemName: "house.fill", withConfiguration: config)
        myGearCollectionView.register(UINib(nibName:String(describing: MyGearCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier:MyGearCollectionViewCell.identifier )
        myGearCollectionView.rx.setDelegate(self)

        loadData()
    } // end viewDidLoad

    func loadData(){
        
        let didSelect = myGearCollectionView.rx
            .modelSelected(ViewGear.self)
            .asDriver()
        
        let input = MyGearViewModel.Input(didSelectCell: didSelect)
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        input.loadGears.onNext(())
        
        viewModel.gears
            .map{ $0.map { ViewGear($0) } }
            .bind(to: myGearCollectionView.rx.items(cellIdentifier: MyGearCollectionViewCell.identifier,cellType: MyGearCollectionViewCell.self)) { (row, element, cell) in
                cell.onData.onNext(element)
            }.disposed(by: disposeBag)
        

        viewModel.gearTypes
            .bind(to: categoryCollectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.identifier, cellType: CategoryCollectionViewCell.self)) { (row, element, cell) in
                
                cell.categoryButton.rx.tap.asDriver()
                    .drive(onNext: { [weak self] in
                        let pushVC = self?.storyboard?.instantiateViewController(withIdentifier: CategoryCollectionViewController.identifier) as! CategoryCollectionViewController
                            pushVC.gearTypeNum = row
                            pushVC.viewModel = self?.viewModel
                        self?.navigationController?.pushViewController(pushVC, animated: true)
                        
                    }).disposed(by: cell.disposeBag)
                cell.updateUI(title: element.gearName)
            }.disposed(by: disposeBag)
        
        
        output.didSelectCell
            .drive(onNext:{ result in
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: GearDetailViewController.identifier) as! GearDetailViewController
                pushVC.gearId = result.id
                pushVC.viewModel = GearDetailViewModel(gearId: result.id)
                self.navigationController?.pushViewController(pushVC, animated: true)
            }).disposed(by: disposeBag)
    }
  

    @IBOutlet weak var myGearCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!

    @IBAction func addGearMove(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AddGearView") as! AddGearViewController
        pushVC.viewModel = viewModel
        self.navigationController?.pushViewController(pushVC, animated: true)
        
    }
    @IBAction func unwind(_ sender: Any) {
        DB.userDefaults.removeObject(forKey: "token")
        DB.userDefaults.set(false, forKey: "Auto")
        ProfileViewModel.shared.clearUserCount()

        performSegue(withIdentifier: "unwindVC1", sender: self)
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
