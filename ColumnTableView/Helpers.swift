//
//  Helpers.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 04/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import UIKit

public extension NSLayoutConstraint {
    public class func activateIfNotActive(_ constraints: [NSLayoutConstraint]){
        let notActive = constraints.filter({!$0.isActive})
        self.activate(notActive)
    }
}


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
}
