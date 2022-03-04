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

class GearDetailViewController: UIViewController, GearDetailReloadable {
    static let identifier: String = "GearDetailViewController"

    var gearId: Int = 0

    let apiManager = APIManager.shared
    let store = Store.shared
    let disposeBag: DisposeBag = DisposeBag()

    var gearDetail: GearDetail?
    var viewModel: GearDetailViewModel!
    var isPermission: Bool = true

    init(viewModel: GearDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    @IBAction func pageChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        gearDetailCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setBind()

    }

    func reloadData() {
        self.viewModel.inputs.loadGearDetail()

    }

    func setView() {
        self.title = "장비 상세"
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.red

        viewModel.inputs.loadGearDetail()
        gearDeleteButton.isHidden = !isPermission
        gearEditButton.isHidden = !isPermission

        gearDeleteButton.rx.tap
            .subscribe(onNext: {
                let alert = UIAlertController(title: nil, message: "장비를 삭제 하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "삭제", style: .default) { _ in
                    self.viewModel.inputs.deleteButtonTouched.accept(())
                    NotificationCenter.default.post(name: .home, object: nil)
                    self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(UIAlertAction(title: "취소", style: .default) { _ in
                    return
                })
                self.present(alert, animated: true)

            })
            .disposed(by: disposeBag)

        gearEditButton.rx.tap
            .subscribe({[weak self] _ in
                guard let self = self else { return }
                guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "GearEditView") as? GearEditViewController else {return}
                pushVC.gearId = self.gearId
                pushVC.gearDetail = self.gearDetail
                pushVC.delegate = self
                self.navigationController?.pushViewController(pushVC, animated: true)
            })
            .disposed(by: disposeBag)

    }

    func setBind() {
        viewModel.outputs.showGearDetail
            .do { self.gearDetail = $0}
            .map { $0.images }
            .do {
                self.pageControl.numberOfPages = $0.count
                self.pageControl.reloadInputViews()
            }
            .bind(to: gearDetailCollectionView.rx.items(cellIdentifier: GearDetailImageCollectionViewCell.identifier, cellType: GearDetailImageCollectionViewCell.self)) { (_, element, cell) in
                cell.onData.onNext(element)
            }.disposed(by: disposeBag)
    }

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var gearDetailCollectionView: UICollectionView!

    @IBOutlet weak var gearEditButton: UIButton!
    @IBOutlet weak var gearDeleteButton: UIButton!

}
extension GearDetailViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width // 너비 저장
              let offSetX = scrollView.contentOffset.x + (width / 2.0) // 현재 스크롤한 x좌표 저장

              let newPage = Int(offSetX / width)
              if pageControl.currentPage != newPage {
                  pageControl.currentPage = newPage
              }
    }
}

extension GearDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
