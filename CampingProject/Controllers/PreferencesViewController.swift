//
//  PreferencesViewController.swift
//  CampingProject
//
//  Created by 고정근 on 2022/03/03.
//

import Foundation
import UIKit
import PanModal

class NavigationController: UINavigationController{
    var id: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let view = self.viewControllers[0] as? PreferencesViewController else {return}
        view.profileView = id
    }
}

class PreferencesViewController: UIViewController{
    
    @IBOutlet weak var preferencesTableView: UITableView!
    
    let items: [String] = ["비밀번호 변경", "회원 탈퇴", "정보"]
    var profileView: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        preferencesTableView.dataSource = self
        preferencesTableView.delegate = self
        
        preferencesTableView.register(UINib(nibName: String(describing: PreferencesTableViewCell.self), bundle: nil), forCellReuseIdentifier: PreferencesTableViewCell.identifier)
    }
}

extension PreferencesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PreferencesTableViewCell.identifier, for: indexPath) as? PreferencesTableViewCell else {return UITableViewCell()}
        cell.preferencesTitle.text = items[indexPath.row]
        
        return cell
    }
}

extension PreferencesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: ChangePasswordViewController.identifier) as? ChangePasswordViewController else {return}
            self.dismiss(animated: true, completion: {
                self.profileView?.navigationController?.pushViewController(pushVC, animated: true)
            })
            
        } else {
            guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: DisregisterViewController.identifier) as? DisregisterViewController else {return}
            self.dismiss(animated: true, completion: {
                self.profileView?.navigationController?.pushViewController(pushVC, animated: true)
            })
        }
      
    }
}

