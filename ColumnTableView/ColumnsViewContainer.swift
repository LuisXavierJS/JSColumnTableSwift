//
//  ColumnsViewContainer.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


class ColumnsViewContainer: UIView {
    private(set) var columns: [ColumnContentView] = []
    
    convenience init(){
        self.init(frame: CGRect.zero)
        self.setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    

    private func setupViews(){

    }
    
    private func deactivateAllConstraints(){
        self.columns.forEach { (c) in
            NSLayoutConstraint.deactivate(c.constraints)
            c.removeFromSuperview()
        }
        NSLayoutConstraint.deactivate(self.constraints)
    }
    
    private func setEdgeConstraints(rightCollumn: ColumnContentView?, leftColumn: ColumnContentView){
        let isFirstColumn = rightCollumn == nil
        
        let horizontalViews = isFirstColumn ? ["column":leftColumn] : ["rightCollumn":rightCollumn!,"column":leftColumn]
        let horizontalDimensionFormat = "H:" + (isFirstColumn ? "|" : "rightCollumn") + "[column]"
        
        var constraintsToActivate: [NSLayoutConstraint] = []
        constraintsToActivate.append(contentsOf:NSLayoutConstraint.constraints(withVisualFormat: horizontalDimensionFormat, metrics: nil, views: horizontalViews))
        constraintsToActivate.append(contentsOf:NSLayoutConstraint.constraints(withVisualFormat: "V:|[column]|", metrics: nil, views: ["column":leftColumn]))
        NSLayoutConstraint.activateIfNotActive(constraintsToActivate)
    }
    
    private func setColumnsEdgesConstraints(){
        var lastColumn: ColumnContentView?
        self.columns.forEach { (column) in
            self.setEdgeConstraints(rightCollumn: lastColumn, leftColumn: column)
            lastColumn = column
        }
        if let column = lastColumn {
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "[column]|", metrics: nil, views: ["column":column]))
        }
    }
    
    private func setColumnsWidthConstraints(){
        //cria constraints de comprimento e seta nas colunas
    }
    
    private func updateColumnsWidthConstraints(){
        //atualiza os valores das constraints de comprimento das colunas
    }
    
    private func setupAllColumns(){
        self.setColumnsEdgesConstraints()
        self.setColumnsWidthConstraints()
    }
    
    private func redistributeSpaceToShowingColumns(spaceToRedistribute space: CGFloat){
        
    }
    
    func hideColumns(_ columns: [Int]) {
        
    }
    
    func showColumns(_ columns: [Int]) {
        
    }
    
    func setColumnFields(_ columns: [UIView]) {
        self.deactivateAllConstraints()
        self.columns = columns.map({return ColumnContentView(withField: $0)})
        self.setupAllColumns()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateColumnsWidthConstraints()
    }
}
