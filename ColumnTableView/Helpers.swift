//
//  Helpers.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 04/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import UIKit

public extension UITableViewCell{
    public weak var tableView: UITableView? {
        var view: UIView? = self
        repeat {
            view = view?.superview
            if let table = view as? UITableView { return table }
        } while view?.superview != nil
        return view as? UITableView
    }
}

extension NSObject {
    public class func className() -> String {
        let moduleClassName = NSStringFromClass(self.classForCoder())
        let className = moduleClassName.components(separatedBy: ".").last!
        return className
    }
    
    func findNext(type: AnyClass) -> Any{
        var resp = self as! UIResponder
        while !resp.isKind(of: type.self) && resp.next != nil {
            resp = resp.next!
        }
        return resp
    }
}

extension ColumnsTableView {
    func registerCellAndHeader<CellType: ColumnsTableViewCell>(forCellType type: CellType.Type) {
        self.register(CellType.self, forCellReuseIdentifier: CellType.className())
        self.register(ColumnsHeaderView<CellType>.self, forHeaderFooterViewReuseIdentifier: ColumnsHeaderView<CellType>.className())
    }
}

extension UITableView {
    func setDataSourceAndDelegate(_ datasource: (UITableViewDelegate&UITableViewDataSource)?){
        self.dataSource = datasource
        self.delegate = datasource
    }
    
    func setDataSourceAndDelegate(jsController datasource: JSTableViewControllerProtocol){
        self.dataSource = datasource.delegateDatasource
        self.delegate = datasource.delegateDatasource
    }
}

extension CGRect {
    func insetBy(lX: CGFloat = 0, rX: CGFloat = 0, tY: CGFloat = 0, bY: CGFloat = 0) -> CGRect {
        return self
            .with(x: self.origin.x + lX)
            .with(width: self.size.width - rX)
            .with(y: self.origin.y + tY)
            .with(height: self.size.height - bY)
    }
    
    func with(x delta: CGFloat) -> CGRect {
        return CGRect(x: delta, y: self.origin.y, width: self.size.width, height: self.size.height)
    }
    func with(y delta: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: delta, width: self.size.width, height: self.size.height)
    }
    func with(width delta: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.y, width: delta, height: self.size.height)
    }
    func with(height delta: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.y, width: self.size.width, height: delta)
    }
}

