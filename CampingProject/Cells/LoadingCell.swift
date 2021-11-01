//
//  LodingCell.swift
//  CampingProject
//
//  Created by 고정근 on 2021/11/01.
//

import Foundation
import UIKit

class LoadingCell: UITableViewCell {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    func start() {
        activityIndicatorView.startAnimating()
    }
}
