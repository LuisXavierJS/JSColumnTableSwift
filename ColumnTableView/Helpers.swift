//
//  Helpers.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 04/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell{
    public weak var tableView: UITableView? {
        var view: UIView? = self
        repeat {
            view = view?.superview
            if let table = view as? UITableView { return table }
        } while view?.superview != nil
        return view as? UITableView
    }
}

extension UIColor {
    static func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
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


