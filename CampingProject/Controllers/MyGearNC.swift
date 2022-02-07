//
//  MyGearNC.swift
//  CampingProject
//
//  Created by 고정근 on 2022/01/07.
//

import Foundation
import UIKit
import RxSwift

class MyGearNC : UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        MyGearViewModel.shared.loadGears()
    }
}

