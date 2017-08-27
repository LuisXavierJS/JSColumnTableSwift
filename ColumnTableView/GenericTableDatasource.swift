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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    @objc optional func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    @objc optional func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    @objc optional func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    
    @objc optional func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
}

fileprivate class TableViewController: NSObject, UITableViewDataSource, UITableViewDelegate {
    fileprivate var items: [[Any]] = []
    weak var delegate: TableViewControllerProtocol!
    
    
    var defaultRowHeight: CGFloat = 44
    var defaultHeaderHeight: CGFloat = -1

    
    //MARK : REQUIRED METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.delegate.tableView(tableView,cellForRowAt:indexPath)
    }
    
    
    //MARK : OPTIONAL METHODS WITH RETURN
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let m = self.delegate.tableView(_:heightForHeaderInSection:) {
            return m(tableView, section)
        }else{
            return self.defaultHeaderHeight
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let m = self.delegate.tableView(_:viewForHeaderInSection:) {
            return m(tableView, section)
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let m = self.delegate.tableView(_:willSelectRowAt:) {
            return m(tableView, indexPath)
        }else{
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let m = self.delegate.tableView(_:heightForRowAt:) {
            return m(tableView, indexPath)
        }else{
            return self.defaultRowHeight
        }
    }
    
    
    //MARK : OPTIONAL METHODS WITHOUT RETURN
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.delegate.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self.delegate.tableView?(tableView, didHighlightRowAt: indexPath)
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
