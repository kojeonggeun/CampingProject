//
//  TableViewDataViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/09.
//

import Foundation

class TableViewDataViewModel {
    
    private let manager = APIService.shared
    
    var tableData: [TableViewCellData] {
        return manager.tableViewData
    }
    

    func numberOfRowsInSection(section: Int) -> Int{
        return tableData[section].name.count
    }
    
    func isOpened(value : Int) -> Bool {
        return tableData[value].isOpened
    }
    
}
