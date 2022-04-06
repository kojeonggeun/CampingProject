//
//  LaunchView.swift
//  Camtorage
//
//  Created by 고정근 on 2022/04/05.
//

import Foundation
import UIKit
import RxSwift

class LaunchViewController: UIViewController{
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.loadConfig()
            .flatMap{AppVersionManager.shared.checkVersion(min:$0.appVersion.minimumVersion)}
            .delay(.microseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ config in
                self.perform(#selector(self.showMain), with: nil)
            }).disposed(by: disposeBag)

     }
    @objc func showMain(){
        self.performSegue(withIdentifier: "SignInView", sender: self)

 }
    
}
