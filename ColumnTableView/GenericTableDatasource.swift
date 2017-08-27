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

@objc protocol TableViewControllerProtocol: class {
    var cellIdentifier: String {get}
    func didDequeue(of cell: UITableViewCell, ofIndexPath index: IndexPath)
    @objc optional func didSelectCell(at index: IndexPath)
}

fileprivate class TableViewController: NSObject, UITableViewDataSource, UITableViewDelegate {
    fileprivate var items: [[Any]] = []
    weak var delegate: TableViewControllerProtocol!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: delegate.cellIdentifier,
                                                 for: indexPath)
        delegate.didDequeue(of: cell, ofIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.didSelectCell?(at: indexPath)
    }
}

class GenericTableController<CellType: SetupableCellProtocol>: NSObject, TableViewControllerProtocol where CellType: UITableViewCell {
    typealias DataType = CellType.DataType
    var items: [[DataType]] = [] {
        didSet{
            self.tableController.items = self.items
        }
    }
    weak var controller: (UITableViewDelegate&UITableViewDataSource)! {
        return self.tableController
    }
    private var tableController = TableViewController()
    fileprivate(set) weak var tableView: UITableView?
    
    var cellIdentifier: String {
        return CellType.className()
    }
    
    init<T:UITableView>(tableView: T){
        self.tableView = tableView
        super.init()
        self.tableController.delegate = self
    }
    
    func reloadData(with items: [[DataType]]) {
        self.items = items
        self.tableView?.reloadData()
    }
    
    func didDequeue(of cell: UITableViewCell, ofIndexPath index: IndexPath) {
        if let setupableCell = cell as? CellType {
            setupableCell.setup(self.items[index.section][index.row])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath) as! CellType
        cell.setup(self.items[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hey yah")
    }
    
}

class GenericColumnsTableController<CellType: SetupableCellProtocol>: GenericTableController<CellType> where CellType: ColumnsTableViewCell {
    var headerIdentifier: String {
        return ColumnsHeaderView<CellType>.className()
    }
    
    weak var columnsTableView: ColumnsTableView? {
        return self.tableView as? ColumnsTableView
    }
    
    override init<T:UITableView>(tableView: T) where T:ColumnsTableView {
        super.init(tableView: tableView)
        self.register()
    }
    
    func register(){
        self.columnsTableView?.registerCellAndHeader(forCellType: CellType.self)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
    }
    

}
