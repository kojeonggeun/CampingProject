//
//  PreferencesViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2022/03/03.
//

import Foundation
import UIKit

class PreferencesViewController: UIViewController {
    
    let myTableView: UITableView = UITableView()
    let items: [String] = ["비밀번호 변경", "회원 탈퇴", "정보"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(UINib(nibName: String(describing: PreferencesTableView.self), bundle: nil), forCellReuseIdentifier: PreferencesTableView.identifier)
        
        self.view.addSubview(self.myTableView)
        
        self.myTableView.translatesAutoresizingMaskIntoConstraints = false
           self.view.addConstraint(NSLayoutConstraint(item: self.myTableView,
             attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top,
             multiplier: 1.0, constant: 0))
           self.view.addConstraint(NSLayoutConstraint(item: self.myTableView,
             attribute: .bottom, relatedBy: .equal, toItem: self.view,
             attribute: .bottom, multiplier: 1.0, constant: 0))
           self.view.addConstraint(NSLayoutConstraint(item: self.myTableView,
             attribute: .leading, relatedBy: .equal, toItem: self.view,
             attribute: .leading, multiplier: 1.0, constant: 0))
           self.view.addConstraint(NSLayoutConstraint(item: self.myTableView,
             attribute: .trailing, relatedBy: .equal, toItem: self.view,
             attribute: .trailing, multiplier: 1.0, constant: 0))
         
    }
}

extension PreferencesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PreferencesTableView.identifier, for: indexPath) as? PreferencesTableView else {return UITableViewCell()}
        cell.preferencesTitle.text = items[indexPath.row]
        
        return cell
    }
}

extension PreferencesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
//        self.dismiss(animated: true, completion: nil)
        
    }
}
