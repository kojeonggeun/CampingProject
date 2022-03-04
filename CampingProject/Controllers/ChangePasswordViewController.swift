//
//  ChangePasswordViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2022/03/03.
//

import Foundation
import UIKit
import PanModal

class ChangePasswordViewController: UIViewController {
    static let identifier = "ChangePasswordViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PreferencesViewController: PanModalPresentable{
    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .maxHeight
    }

    var shortFormHeight: PanModalHeight {
        return longFormHeight
    }
}
