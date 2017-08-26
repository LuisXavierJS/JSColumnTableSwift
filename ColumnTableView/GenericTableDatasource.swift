//
//  GenericTableDatasource.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 26/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


@objc protocol SetupableCellProtocol: class {
    func setup(_ object: NSObject)
}

class GenericTableDatasource<DataType: NSObject, CellType: ColumnsTableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate {
    fileprivate(set) var items: [DataType]!
    fileprivate(set) weak var tableView: ColumnsTableView?
    var cellIdentifier: String {
        return CellType.className()
    }
    
    var headerIdentifier: String {
        return ColumnsHeaderView<CellType>.className()
    }
    
    init(tableView: ColumnsTableView, mockMode: Bool = false){
        self.tableView = tableView
        super.init()
        self.register()
    }
    
    func register(){
        self.tableView?.registerCellAndHeader(forCellType: CellType.self)
    }
    
    func setItems(items: [Any]) {
        self.items = items as! [DataType]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath) as! SetupableCellProtocol
        cell.setup(self.items[indexPath.row])
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
    }
}
