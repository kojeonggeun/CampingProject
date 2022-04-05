//
//  LaunchView.swift
//  Camtorage
//
//  Created by 고정근 on 2022/04/05.
//

import Foundation
import UIKit
import RxSwift

class LaunchView: UIViewController{
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        AppVersionManager.sharedManager.checkVersion()
            .subscribe({ _ in
                self.perform(#selector(self.showMain), with: nil)
            }).disposed(by: disposeBag)
     }

     @objc func showMain(){
         self.performSegue(withIdentifier: "SignInView", sender: self)

     }
    
}
