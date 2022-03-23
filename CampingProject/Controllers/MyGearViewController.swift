//  First.swift
//  CampingProject
//
//  Created by 고정근 on 2021/08/07.

import UIKit
import RxSwift
import RxCocoa
class MyGearViewController: UIViewController {
    
    let apiManager = APIManager.shared
    var collectionIndexPath = IndexPath()
    var viewModel = MyGearViewModel()
    var disposeBag: DisposeBag = DisposeBag()

    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setBind()
        setNotification()
    }

    func setNotification() {
        NotificationCenter.default.rx.notification(.home)
                    .subscribe(onNext: { [weak self] _ in
                        self?.viewModel.loadGears()
                    }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(.delete)
                    .subscribe(onNext: { [weak self] _ in
                        self?.viewModel.loadGears()
                    }).disposed(by: disposeBag)
    }

    func setView() {
        let config = UIImage.SymbolConfiguration(scale: .small)
        navigationController?.tabBarItem.image = UIImage(systemName: "house.fill", withConfiguration: config)
        myGearCollectionView.register(UINib(nibName: String(describing: MyGearCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: MyGearCollectionViewCell.identifier)

        myGearCollectionView.rx.setDelegate(self)
        viewModel.inputs.loadGears()
        viewModel.inputs.loadGearTypes()

    }

    func setBind() {
        viewModel.outputs.gears
            .map { $0.map { ViewGear($0) } }
            .bind(to: myGearCollectionView.rx.items(cellIdentifier: MyGearCollectionViewCell.identifier, cellType: MyGearCollectionViewCell.self)) { (_, element, cell) in
                cell.onData.onNext(element)
            }.disposed(by: disposeBag)

        viewModel.outputs.gearTypes
            .asDriver(onErrorJustReturn: [GearType.init(gearID: 0, gearName: "")])
            .drive(categoryCollectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.identifier, cellType: CategoryCollectionViewCell.self)) { (row, element, cell) in
                cell.categoryButton.rx.tap.asDriver()
                    .drive(onNext: { [weak self] in
                        guard let pushVC = self?.storyboard?.instantiateViewController(withIdentifier: CategoryCollectionViewController.identifier) as? CategoryCollectionViewController else {return}
                            pushVC.gearTypeNum = row
                            pushVC.viewModel = self?.viewModel
                        self?.navigationController?.pushViewController(pushVC, animated: true)

                    }).disposed(by: cell.disposeBag)
                cell.updateUI(title: element.gearName)
            }.disposed(by: disposeBag)

        myGearCollectionView.rx.modelSelected(ViewGear.self)
            .subscribe(onNext: { result in
                guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: GearDetailViewController.identifier) as? GearDetailViewController else {return}
                pushVC.gearId = result.id
                
                pushVC.viewModel = GearDetailViewModel(gearId: result.id,userId: self.apiManager.userInfo!.user!.id)

                self.navigationController?.pushViewController(pushVC, animated: true)
            })
            .disposed(by: disposeBag)
    }

    @IBOutlet weak var myGearCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!

    @IBAction func addGearMove(_ sender: Any) {
        guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AddGearView") as? AddGearViewController else {return}
        pushVC.viewModel = viewModel
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    @IBAction func unwind(_ sender: Any) {
        DB.userDefaults.removeObject(forKey: "token")
        DB.userDefaults.set(false, forKey: "Auto")

        performSegue(withIdentifier: "unwindVC1", sender: self)
    }
}

extension MyGearViewController: UICollectionViewDelegateFlowLayout {
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
