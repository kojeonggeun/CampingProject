//
//  CategoryCollectionViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/15.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CategoryCollectionViewController: UIViewController {

    static let identifier: String  = "CategoryCollectionViewController"

    let disposeBag = DisposeBag()

    var viewModel: MyGearViewModel!

    var gearTypeNum: Int = 0
    var gearType: String = ""

    init(viewModel: MyGearViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.gearTypes.do { self.gearType = $0[self.gearTypeNum].gearName }.subscribe().disposed(by: disposeBag)
        self.title = gearType

        categoryCollectionView.register(UINib(nibName: String(describing: MyGearCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: MyGearCollectionViewCell.identifier)

        categoryCollectionView.rx.setDelegate(self)

        setBind()

    }

    func setBind() {
        viewModel.gears
            .map {
                $0.filter { $0.gearTypeName == self.gearType}
            }
            .map { $0.map { ViewGear($0) } }
            .bind(to: categoryCollectionView.rx.items(cellIdentifier: MyGearCollectionViewCell.identifier, cellType: MyGearCollectionViewCell.self)) { (_, element, cell) in
                cell.onData.onNext(element)
            }.disposed(by: disposeBag)

        categoryCollectionView.rx.modelSelected(ViewGear.self)
            .subscribe(onNext: { cell in
                guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: GearDetailViewController.identifier) as? GearDetailViewController else {return}
                pushVC.gearId = cell.id
                pushVC.viewModel = GearDetailViewModel(gearId: cell.id)
                self.navigationController?.pushViewController(pushVC, animated: true)
            }).disposed(by: disposeBag)
    }

    @IBOutlet var categoryCollectionView: UICollectionView!
}

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let margin: CGFloat = 10
            let itemSpacing: CGFloat = 10

            let width = (collectionView.frame.width - margin * 2 - itemSpacing) / 2
            let height = width * 10/7.5

            return CGSize(width: width, height: height)
    }
}
