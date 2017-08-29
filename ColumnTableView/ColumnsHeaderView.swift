//
//  ColumnsHeaderView.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

open class ColumnsHeaderView<T:ColumnsTableViewCell>: UITableViewHeaderFooterView, ColumnsViewProtocol {
    private var lastLayoutedBounds: CGRect = CGRect.zero
    
    private var columnsViewContainerCell: T = T()
    
    open weak var columnsViewContainer: ColumnsViewContainer! {
        return self.columnsViewContainerCell.containerView
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }

    private func setupViews(){
        self.columnsViewContainerCell.setupViews()
        self.addSubview(self.columnsViewContainer)
        self.columnsViewContainer.setHeaderMode(true)
    }
    
    open func hideColumns(_ columns: [Int]){
        self.columnsViewContainer.hideColumns(columns)
    }
    
    open func showColumns(_ columns: [Int]){
        self.columnsViewContainer.showColumns(columns)
    }
    
    func calculateSubviewsFrames(for base: CGRect){
        self.columnsViewContainer.frame = base
    }
    
    func baseSubviewsArea() -> CGRect {
        return self.bounds
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.lastLayoutedBounds != self.bounds {
            self.calculateSubviewsFrames(for: self.baseSubviewsArea())
        }
        self.lastLayoutedBounds = self.bounds
    }
}
