//
//  ColumnsHeaderView.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ColumnsHeaderView<T:ColumnsTableViewCell>: UITableViewHeaderFooterView, ColumnHeaderControllerDelegate {
    private var columnsViewContainerCell: T = T()
    
    weak var columnsViewContainer: ColumnsViewContainer! {
        return self.columnsViewContainerCell.containerView
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }

    private func setupViews(){
        self.columnsViewContainerCell.setupViews()
        self.columnsViewContainer.headerDelegate = self
        self.columnsViewContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.columnsViewContainer)
        var containerConstraints: [NSLayoutConstraint] = []
        containerConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", metrics: nil, views: ["container":self.columnsViewContainer]))
        containerConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[container]|", metrics: nil, views: ["container":self.columnsViewContainer]))
        NSLayoutConstraint.activateIfNotActive(containerConstraints)
        self.columnsViewContainer.setHeaderMode(true)
    }
    
    func hideColumns(_ columns: [Int]){
        self.columnsViewContainer.hideColumns(columns)
    }
    
    func showColumns(_ columns: [Int]){
        self.columnsViewContainer.showColumns(columns)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
