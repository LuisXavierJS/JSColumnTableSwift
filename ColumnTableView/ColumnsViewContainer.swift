//
//  ColumnsViewContainer.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


@objc protocol ColumnsViewContainerController: class {
    @objc optional var mainColumnIndex: Int {get}
    @objc optional func initialFixedWidthForColumn(at index: Int) -> CGFloat
}

class ColumnsViewContainer: UIView {
    private(set) var columns: [ColumnContentView] = []
    weak var delegate: ColumnsViewContainerController?
    
    
    
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
        let rightView = (isFirstColumn ? "|" : "rightCollumn")
        let horizontalDimensionFormat = "H:" + rightView + "[column]"
        
        var constraintsToActivate: [NSLayoutConstraint] = []
        constraintsToActivate.append(contentsOf:NSLayoutConstraint.constraints(withVisualFormat: horizontalDimensionFormat,
                                                                               metrics: nil,
                                                                               views: horizontalViews))
        constraintsToActivate.append(contentsOf:NSLayoutConstraint.constraints(withVisualFormat: "V:|[column]|",
                                                                               metrics: nil,
                                                                               views: ["column":leftColumn]))
        NSLayoutConstraint.activateIfNotActive(constraintsToActivate)
    }
    
    private func setColumnsEdgesConstraints(){
        var lastColumn: ColumnContentView?
        self.columns.forEach { (column) in
            self.setEdgeConstraints(rightCollumn: lastColumn, leftColumn: column)
            lastColumn = column
        }
        if let column = lastColumn {
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "[column]|",
                                                                       metrics: nil,
                                                                       views: ["column":column]))
        }
    }
    
    private func getInitialWidthDefinitionsOfColumns() -> [(column: Int, width: CGFloat)]{
        var widthDefinitions: [(column: Int, width: CGFloat)] = []
        var index = 0
        var totalColumnsWidth: CGFloat = 0
        self.columns.forEach { _ in
            let preferredWidth = self.delegate?.initialFixedWidthForColumn?(at: index) ?? self.bounds.width/CGFloat(self.columns.count)
            let width = min(preferredWidth, self.bounds.width - (totalColumnsWidth + preferredWidth))
            widthDefinitions.append((column: index, width: width))
            totalColumnsWidth+=width
            index+=1
        }
        return widthDefinitions
    }
    
    private func setColumnsWidthConstraints(){
        //cria constraints de comprimento e seta nas colunas
        var constraintsToActivate: [NSLayoutConstraint] = []
        let widthDefinitions = self.getInitialWidthDefinitionsOfColumns()
        let mainColumnIndex = self.delegate?.mainColumnIndex ?? widthDefinitions.sorted(by: {$0.width > $1.width}).first?.column ?? 0
        widthDefinitions.forEach { (columnIndex,width) in
            let relation: NSLayoutRelation = columnIndex == mainColumnIndex ? .greaterThanOrEqual : .equal
            let constraint = NSLayoutConstraint(item: self.columns[columnIndex],
                                                attribute: .width,
                                                relatedBy: relation,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: width)
            constraintsToActivate.append(constraint)
            self.columns[columnIndex].setWidth(constraint: constraint)
        }
        NSLayoutConstraint.activateIfNotActive(constraintsToActivate)
    }
    
    private func updateColumnsWidthConstraints(){
        //atualiza os valores das constraints de comprimento das colunas
    }
    
    private func setupAllColumns(){
        if self.columns.count > 0 {
            self.setColumnsEdgesConstraints()
            self.setColumnsWidthConstraints()
        }
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
