//
//  TableViewDataViewModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/09/09.
//

import Foundation

class TableViewViewModel {
    
    private let manager = APIManager.shared
    
    var tableViewData: [TableViewCellData] {
            return manager.tableViewData
        }
   
    func numberOfRowsInSection(section: Int) -> Int{

        return tableViewData[section].name.count
        
    }
    
    func articleAtIndex(_ index: Int) -> TableViewDataViewModel {
        let data = self.tableViewData[index]
        return TableViewDataViewModel(data)
    }
}


struct TableViewDataViewModel {
    private let tableData: TableViewCellData
    
    init(_ data: TableViewCellData) {
        self.tableData = data
    }

    var gearId: [Int] {
        return self.tableData.gearId
    }
    var isOpened: Bool {
        return self.tableData.isOpened
    }
    var gearTypeName: String {
        return self.tableData.gearTypeName
    }
    var name: [String] {
        return self.tableData.name
    }
}

