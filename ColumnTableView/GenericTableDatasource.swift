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

@objc protocol JSTableViewControllerProtocol: class {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    @objc optional func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    @objc optional func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    @objc optional func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    @objc optional func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    @objc optional func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    @objc optional func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    @objc optional func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
    @objc optional func sectionIndexTitles(for tableView: UITableView) -> [String]?
    @objc optional func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool
    @objc optional func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    @objc optional func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?
    @objc optional func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?
    @objc optional func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    @objc optional func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool
    @objc optional func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    @objc optional func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int
    
    @objc optional func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
}

fileprivate class JSTableViewController: NSObject, UITableViewDataSource, UITableViewDelegate {
    fileprivate var items: [[Any]] = []
    weak var delegate: JSTableViewControllerProtocol!
    
    
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        <#code#>
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        <#code#>
    }
    
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if let m = self.delegate.tableView(_:shouldHighlightRowAt:) {return m(tableView, indexPath)}
        else{return true}
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        if let m = self.delegate.tableView(_:shouldIndentWhileEditingRowAt:) {return m(tableView, indexPath)}
        else{return true}
    }
    
    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        if let m = self.delegate.tableView(_:shouldUpdateFocusIn:) {return m(tableView, context)}
        else{return tableView.shouldUpdateFocus(in: context)}
    }
    
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let m = self.delegate.tableView(_:heightForHeaderInSection:) {return m(tableView, section)}
        else{return self.defaultHeaderHeight}
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

class JSGenericTableController<CellType: SetupableCellProtocol>: NSObject, JSTableViewControllerProtocol where CellType: UITableViewCell {
    typealias DataType = CellType.DataType
    var items: [[DataType]] = [] {
        didSet{
            self.tableController.items = self.items
        }
    }
    weak var controller: (UITableViewDelegate&UITableViewDataSource)! {
        return self.tableController
    }
    private var tableController = JSTableViewController()
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

class JSGenericColumnsTableController<CellType: SetupableCellProtocol>: JSGenericTableController<CellType> where CellType: ColumnsTableViewCell {
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
