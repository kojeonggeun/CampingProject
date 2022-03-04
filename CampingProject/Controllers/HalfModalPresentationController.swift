//
//  PreferencesViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2022/03/03.
//

import Foundation
import UIKit

class HalfModalPresentationController: UIPresentationController{
    
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var check: Bool = false
       
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
       let blurEffect = UIBlurEffect(style: .dark)
       blurEffectView = UIVisualEffectView(effect: blurEffect)
       super.init(presentedViewController: presentedViewController, presenting: presentedViewController)
       tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
       blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       self.blurEffectView.isUserInteractionEnabled = true
       self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
//        origin은 좌표값 x,y size는 뷰의 넓이와 높이
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 600 / 800),
              size: CGSize(width: self.containerView!.frame.width,
                           height: self.containerView!.frame.height / 3))
        
    }

    // 모달이 올라갈 때 뒤에 있는 배경을 검은색 처리해주는 용도
    override func presentationTransitionWillBegin() {
        
       self.blurEffectView.alpha = 0
       self.containerView!.addSubview(blurEffectView)
       self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in self.blurEffectView.alpha = 0.7},
                                                                   completion: nil)
    }
    // 모달이 없어질 때 검은색 배경을 슈퍼뷰에서 제거
     override func dismissalTransitionWillBegin() {
         self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in self.blurEffectView.alpha = 0},
                                                                     completion: { _ in self.blurEffectView.removeFromSuperview()})
     }
     
     // 모달의 크기가 조절됐을 때 호출되는 함수
     override func containerViewDidLayoutSubviews() {
         super.containerViewDidLayoutSubviews()
         blurEffectView.frame = containerView!.bounds
         presentedView?.frame = frameOfPresentedViewInContainerView
         presentedView?.layer.cornerRadius = 22
         
     }
     
     @objc func dismissController() {
         self.presentedViewController.dismiss(animated: true, completion: nil)
     }
}
