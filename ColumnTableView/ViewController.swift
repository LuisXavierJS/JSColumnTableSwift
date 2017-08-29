//
//  ViewController.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: ColumnsTableView!
    var tableDatasource: SpecialColumnsDatasource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableDatasource = SpecialColumnsDatasource(columnsTableView: self.tableView)
    }

}

