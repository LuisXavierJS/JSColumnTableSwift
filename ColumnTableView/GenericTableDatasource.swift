//
//  GenericTableDatasource.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 26/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


protocol SetupableCellProtocol: class {
    associatedtype DataType
    func setup(_ object: DataType)
}

class GenericTableController<CellType: SetupableCellProtocol>: NSObject, UITableViewDataSource, UITableViewDelegate where CellType: UITableViewCell {
    typealias DataType = CellType.DataType
    var items: [[DataType]] = []
    fileprivate(set) weak var tableView: ColumnsTableView?
    
    var cellIdentifier: String {
        return CellType.className()
    }
    
    init(tableView: ColumnsTableView){
        self.tableView = tableView
        super.init()
    }
    
    func reloadData(with items: [[DataType]]) {
        self.items = items
        self.tableView?.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath) as! CellType
        cell.setup(self.items[indexPath.section][indexPath.row])
        return cell
    }
    
}

class GenericColumnsTableController<CellType: SetupableCellProtocol>: GenericTableController<CellType> where CellType: ColumnsTableViewCell {
    
    var headerIdentifier: String {
        return ColumnsHeaderView<CellType>.className()
    }
    
    override init(tableView: ColumnsTableView) {
        super.init(tableView: tableView)
        self.register()
    }
    
    func register(){
        self.tableView?.registerCellAndHeader(forCellType: CellType.self)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
    }
}
