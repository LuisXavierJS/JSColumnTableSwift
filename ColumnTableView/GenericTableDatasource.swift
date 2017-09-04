//
//  GenericTableDatasource.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 26/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


public protocol JSSetupableCellProtocol: class {
    associatedtype DataType
    func setup(_ object: DataType)
}

@objc public protocol JSTableViewControllerProtocol: class {
    var delegateDatasource: JSTableViewDelegateDatasource {get set}
    func numberOfSections(in tableView: UITableView) -> Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    //Optional methods alphabetically sorted (yay)
    @objc optional func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?
    @objc optional func sectionIndexTitles(for tableView: UITableView) -> [String]?
    @objc optional func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool
    @objc optional func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int)
    @objc optional func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int)
    @objc optional func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)
    @objc optional func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)
    @objc optional func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    @objc optional func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    @objc optional func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int
    @objc optional func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?)
    @objc optional func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    @objc optional func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool
    @objc optional func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
    @objc optional func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    @objc optional func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    @objc optional func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    @objc optional func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    @objc optional func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    @objc optional func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?
    @objc optional func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
    @objc optional func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    @objc optional func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    @objc optional func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
}

open class JSTableViewDelegateDatasource: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: JSTableViewControllerProtocol!
    
    //MARK: REQUIRED METHODS
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.delegate.numberOfSections(in:tableView)
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delegate.tableView(tableView,numberOfRowsInSection:section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.delegate.tableView(tableView,cellForRowAt:indexPath)
    }
    
    //MARK: OPTIONAL METHODS
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.delegate.tableView?(tableView,viewForHeaderInSection:section)
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.delegate.tableView?(tableView,viewForFooterInSection:section)
    }
    
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return self.delegate.tableView?(tableView,editActionsForRowAt:indexPath)
    }
    
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return self.delegate.tableView?(tableView,editingStyleForRowAt:indexPath) ?? .none
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.tableView?(tableView, didSelectRowAt: indexPath)
    }
}

open class JSGenericTableController<CellType: JSSetupableCellProtocol>: NSObject, JSTableViewControllerProtocol where CellType: UITableViewCell {
    public typealias DataType = CellType.DataType
    
    open var items: [[DataType]] = []
    
    open lazy var delegateDatasource: JSTableViewDelegateDatasource = {
        return JSTableViewDelegateDatasource()
    }()
    
    open weak var tableView: UITableView?
    
    open var cellIdentifier: String {
        return CellType.className()
    }
    
    public init<T:UITableView>(tableView: T){
        self.tableView = tableView
        super.init()
        self.delegateDatasource.delegate = self
    }
    
    public func reloadData(with items: [[DataType]]) {
        self.items = items
        self.tableView?.reloadData()
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath) as! CellType
        cell.setup(self.items[indexPath.section][indexPath.row])
        return cell
    }
    
}

open class JSGenericColumnsTableController<CellType: JSSetupableCellProtocol>: JSGenericTableController<CellType> where CellType: ColumnsTableViewCell {
    open var headerIdentifier: String {
        return ColumnsHeaderView<CellType>.className()
    }
    
    open weak var columnsTableView: ColumnsTableView? {
        return self.tableView as? ColumnsTableView
    }
    
    public init(columnsTableView: ColumnsTableView) {
        super.init(tableView: columnsTableView)
        self.register()
        self.tableView?.sectionHeaderHeight = 40
        self.tableView?.estimatedSectionHeaderHeight = 40
    }
    
    open func register(){
        self.columnsTableView?.registerCellAndHeader(forCellType: CellType.self)
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
    }
    
}
