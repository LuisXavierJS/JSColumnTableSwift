//
//  ViewController.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableColumnsVisibilityControllerDelegate {
    
    let colors: [[UIColor]] = [[#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1),#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)],[#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1),#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)]]
    
    @IBOutlet weak var tableView: ColumnsTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SpecialColumnsTableViewCell.self, forCellReuseIdentifier: "PrototypeCell")
        self.tableView.register(ColumnsHeaderView<SpecialColumnsTableViewCell>.self, forHeaderFooterViewReuseIdentifier: "PrototypeHeader")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 90
        self.tableView.columnsControllerDelegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func hideColumns(forTable: ColumnsTableView) -> [Int] {
        return []
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "PrototypeHeader")
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrototypeCell", for: indexPath) as! SpecialColumnsTableViewCell
        cell.contentView.backgroundColor = colors[indexPath.section][indexPath.row]
        cell.nome.text = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis "
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .destructive, title: "DELETE", handler: { (_, _) in
            print("ACTION!")
        })]
    }
}

