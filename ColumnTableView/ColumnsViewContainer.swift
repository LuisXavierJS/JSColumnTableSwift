//
//  ColumnsViewContainer.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


@objc protocol ColumnsViewContainerController: class {
    var columnsFields: [ColumnFieldContent] {get}
    
//  Informa coluna que preferencialmente tera seu tamanho variavel conforme a variacao de tamanho da superview e das demais colunas
// - Se nao for implementado, o default sera assumido como a coluna de maior tamanho na tabela.
    @objc optional var mainColumnIndex: Int {get}
    
//  Informa a prioridade para ajuste de comprimento de uma determinada coluna, caso outra coluna seja ocultada ou exibida no container.
// - Se nao for implementado, a prioridade de redimensionamento sera igual para todas as colunas
// - Se a soma de prioridade de todas as colunas for inferior a 0 ou superior a 100, as colunas finais podem nao respeitar as prioridades de redimensionamento desejadas.
    @objc optional func redimensioningPriority(forColumnAt index: Int) -> CGFloat
    
//  Informa o tamanho do campo dentro da coluna
// - Se nao for implementado, o campo tera um tamanho exatamente igual ao da coluna.
// - Se o tamanho for invalido (menor que CGSize.zero ou maior que o tamanho da coluna), o campo tera o tamanho igual ao da coluna.
    @objc optional func preferredSizeForField(ofColumnAt index: Int) -> CGSize
    
//  Informa a preferencia de largura inicial para uma coluna durante o layout:
// -  Se nao for implementado, a preferencia de largura inicial sera igual para todas as colunas.
// -  Se for implementado mas retornar valores que nao representem o real tamanho da ColumnsViewCell, as colunas finais podem desaparecer ou a mainColumn pode aumentar para compensar a diferenca de tamanho.
    @objc optional func preferredInitialFixedWidthForColumn(at index: Int) -> CGFloat
}

class ColumnsViewContainer: UIView {
    private(set) var columns: [ColumnContentView] = []
    weak var mainColumn: ColumnContentView?
    weak var delegate: ColumnsViewContainerController!
    
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
        let rightView = (isFirstColumn ? "|" : "[rightCollumn]")
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
    
    private func createAndSetColumnsEdgesConstraints(){
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
    
    private func getWidthDefinitionsOfColumns() -> [(column: Int, width: CGFloat)]{
        var widthDefinitions: [(column: Int, width: CGFloat)] = []
        var index = 0
        var totalColumnsWidth: CGFloat = 0
        self.columns.forEach { _ in
            let preferredWidth = self.delegate?.preferredInitialFixedWidthForColumn?(at: index) ?? self.bounds.width/CGFloat(self.columns.count)
            let width = min(preferredWidth, max(self.bounds.width - totalColumnsWidth,0))
            widthDefinitions.append((column: index, width: width))
            totalColumnsWidth+=width
            index+=1
        }
        return widthDefinitions
    }
    
    private func createAndSetColumnsWidthConstraints(){
        var constraintsToActivate: [NSLayoutConstraint] = []
        let widthDefinitions = self.getWidthDefinitionsOfColumns()
        let mainColumnIndex = self.delegate?.mainColumnIndex ?? widthDefinitions.sorted(by: {$0.width > $1.width}).first?.column ?? 0
        self.mainColumn = self.columns[mainColumnIndex]
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
        let widthDefinitions = self.getWidthDefinitionsOfColumns()
        widthDefinitions.forEach { (columnIndex,width) in
            self.columns[columnIndex].updateShowingModeWidth(width)
        }
    }
    
    private func setupAllColumns(){
        if self.columns.count > 0 {
            self.createAndSetColumnsEdgesConstraints()
            self.createAndSetColumnsWidthConstraints()
        }
    }
    
    private func redistributeSpaceToShowingColumns(spaceToRedistribute space: CGFloat){
        
    }
    
    private func setColumnFields(_ columns: [ColumnFieldContent]) {
        self.deactivateAllConstraints()
        self.columns = columns.map({return ColumnContentView(withField: $0)})
        self.columns.forEach { c in
            self.addSubview(c)
        }
        self.setupAllColumns()
    }
    
    func hideColumns(_ columns: [Int]) {
        
    }
    
    func showColumns(_ columns: [Int]) {
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setColumnFields(self.delegate.columnsFields)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateColumnsWidthConstraints()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.verticalSizeClass == .compact &&
            previousTraitCollection?.horizontalSizeClass == .compact &&
            self.traitCollection.verticalSizeClass == .regular,
            let constraint = self.mainColumn?.widthConstraint {
                NSLayoutConstraint.deactivate([constraint])
        }else{
            if let constraint = self.mainColumn?.widthConstraint {
                NSLayoutConstraint.activateIfNotActive([constraint])
            }
        }
    }

}
