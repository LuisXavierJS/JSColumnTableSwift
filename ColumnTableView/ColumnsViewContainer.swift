//
//  ColumnsViewContainer.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


@objc protocol ColumnsViewContainerControllerDelegate: class {
    var columnsFields: [ColumnFieldContent] {get}
    
//  Informa coluna que preferencialmente tera seu tamanho variavel conforme a variacao de tamanho da superview e das demais colunas
// - Se nao for implementado, o default sera assumido como a coluna de maior tamanho na tabela.
    @objc optional var mainColumnIndex: Int {get}
    
//  Informa a prioridade para ajuste de comprimento de uma determinada coluna, caso outra coluna seja ocultada ou exibida no container.
// - Se nao for implementado, a prioridade de redimensionamento sera igual para todas as colunas
// - Se a soma de prioridade de todas as colunas for inferior a 0 ou superior a 100, as colunas finais podem nao respeitar as prioridades de redimensionamento desejadas.
    @objc optional func redimensioningPriority(forColumnAt index: Int) -> CGFloat
    
//  Informa a preferencia de largura inicial para uma coluna durante o layout:
// -  Se nao for implementado, a preferencia de largura inicial sera igual para todas as colunas.
// -  Se for implementado mas retornar valores que nao representem o real tamanho da ColumnsViewCell, as colunas finais podem desaparecer ou a mainColumn pode aumentar para compensar a diferenca de tamanho.
    @objc optional func preferredInitialFixedWidth(forColumnAt index: Int) -> CGFloat
    
//  Informa a preferencia de largura inicial para uma coluna durante o layout:
// -  Se nao for implementado, a preferencia de largura inicial sera igual para todas as colunas.
// -  Se for implementado mas retornar valores que nao representem o real tamanho da ColumnsViewCell, as colunas finais podem desaparecer ou a mainColumn pode aumentar para compensar a diferenca de tamanho.
    @objc optional func preferredRelativeWidth(forColumnAt index: Int) -> CGFloat
}

@objc protocol ColumnHeaderControllerDelegate: class {
//  Informa qual a fonte utilizada para o titulo do label de cabecalho de uma determinada coluna
// - Se nao for implementado, utiliza a font padrao de um label
    @objc optional func fontForHeader(forColumnAt index: Int) -> UIFont
    
//  Informa o tipo de cabecalho para uma determinada coluna (Se vai ser um label de titulo, o proprio campo ou nada)
// - Se nao for implementado, utiliza o default (label de titulo)
    @objc optional func headerMode(forColumnAt index: Int) -> ColumnFieldHeaderMode
}

class ColumnsViewContainer: UIView {
    
    private enum VariationSpaceMode: Int {
        case hide = -1
        case show = 1
    }
    
    private(set) var columns: [ColumnContentView] = []
    private lazy var spaceVariations: [CGFloat] = {
        return (0..<self.columns.count).map({_ in CGFloat(0)})
    }()
    
    weak var mainColumn: ColumnContentView?
    weak var delegate: ColumnsViewContainerControllerDelegate!
    weak var headerDelegate: ColumnHeaderControllerDelegate?
    
    var normalModeBackgroundColor: UIColor = UIColor.clear
    var headerModeBackgroundColor: UIColor = UIColor.lightGray
    
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
    
    private func deactivateCurrentAllColumnsAndConstraints(){
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
    
    private func createAndSetColumnsWidthConstraints(){
        var constraintsToActivate: [NSLayoutConstraint] = []
        let widthDefinitions = self.getWidthDefinitionsOfColumns()
        let mainColumnIndex = self.delegate?.mainColumnIndex ?? widthDefinitions.sorted(by: {$0.preferredWidth > $1.preferredWidth}).first?.column ?? 0
        self.mainColumn = self.columns[mainColumnIndex]
        widthDefinitions.forEach { (columnIndex,width,_) in
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
    
    private func getWidthDefinitionsOfColumns() -> [(column: Int, width: CGFloat, preferredWidth: CGFloat)]{
        var widthDefinitions: [(column: Int, width: CGFloat, preferredWidth: CGFloat)] = []
        var index = 0
        var totalColumnsWidth: CGFloat = 0
        self.columns.forEach { _ in
            var calculatedPreferredWidth: CGFloat = 0
            var preferred: CGFloat = 0
            var width: CGFloat = 0
            if let preferredRelativeWidth = self.delegate?.preferredRelativeWidth?(forColumnAt: index){
                preferred = preferredRelativeWidth
                calculatedPreferredWidth = preferredRelativeWidth * self.bounds.width
            }else{
                let delegatePreferredWidth = self.delegate?.preferredInitialFixedWidth?(forColumnAt: index)
                calculatedPreferredWidth = delegatePreferredWidth ?? self.bounds.width/CGFloat(self.columns.count)
                preferred = calculatedPreferredWidth
            }
            width = min(calculatedPreferredWidth, max(self.bounds.width - totalColumnsWidth,0))
            widthDefinitions.append((column: index, width: width, preferredWidth: preferred))
            totalColumnsWidth+=width
            index+=1
        }
        return widthDefinitions
    }
    
    private func updateColumnsWidthConstraints(){
        let widthDefinitions = self.getWidthDefinitionsOfColumns()
//        self.redistributeSpace(forColumns: columns, forMode: .hide)
        self.redistributeSpaceOfColumns(forSpaceVariation: self.calculateSpaceVariation(), forMode: .hide)
        widthDefinitions.forEach { (columnIndex,width,_) in
            self.columns[columnIndex].updateShowingModeWidth(width+self.spaceVariations[columnIndex])
        }
    }
    
    private func setupAllColumns(){
        if self.columns.count > 0 {
            self.columns.forEach({self.addSubview($0)})
            self.createAndSetColumnsEdgesConstraints()
            self.createAndSetColumnsWidthConstraints()
            self.hideColumns([0,1,2])
        }
    }
    
    private func redistributeSpaceOfColumns(forSpaceVariation space: CGFloat, forMode mode: VariationSpaceMode){
        var totalSpace: CGFloat = 0
        for columnIndex in 0..<self.columns.count {
            self.spaceVariations[columnIndex] = 0
            if self.columns[columnIndex].isShowing {
                if let priorityForColumn = self.delegate.redimensioningPriority?(forColumnAt: columnIndex),
                    priorityForColumn > 0 && priorityForColumn < 1 && totalSpace < space{
                    let variation = space * priorityForColumn
                    totalSpace+=variation
                    self.spaceVariations[columnIndex]+=variation
                }else{
                    let showingColumns = (self.columns.filter({$0.isShowing}).count)
                    let variation = (space * (1/CGFloat(showingColumns)))
                    if variation + totalSpace >= space {
                        self.spaceVariations[columnIndex]+=(space - totalSpace)
                    }else{
                        self.spaceVariations[columnIndex]+=variation
                    }
                }
            }
        }
    }
    
    private func calculateSpaceVariation() -> CGFloat{
        var spaceVariation: CGFloat = 0
        self.columns.filter({!$0.isShowing}).forEach({spaceVariation+=$0.showingModeWidth})
        if spaceVariation == 0 {
            self.getWidthDefinitionsOfColumns().forEach({ (columnIndex,width,_) in
                if !self.columns[columnIndex].isShowing {
                    spaceVariation+=width
                }
            })
        }
        return spaceVariation
    }
    
    private func redistributeSpace(forColumns columns: [Int], forMode mode: VariationSpaceMode){
//        let spaceVariation = self.calculateSpaceVariation(forColumn: columns)
//        self.redistributeSpaceOfColumns(forSpaceVariation: spaceVariation, forMode: mode)
    }
    
    private func setColumnFields(_ columns: [ColumnFieldContent]) {
        self.deactivateCurrentAllColumnsAndConstraints()
        self.columns = columns.map({return ColumnContentView(withField: $0)})
        self.setupAllColumns()
    }
    
    func hideColumns(_ columns: [Int]) {
        let columnsToShow = Array<Int>(0..<self.columns.count).filter({!columns.contains($0) && !self.columns[$0].isShowing})
        self.showColumns(columnsToShow)
        columns.forEach({self.columns[$0].hide()})
    }
    
    func showColumns(_ columns: [Int]) {
        columns.forEach({self.columns[$0].show()})
    }
    
    func setHeaderMode(_ on: Bool){
        self.backgroundColor = on ? self.headerModeBackgroundColor : self.normalModeBackgroundColor
        var index: Int = 0
        self.columns.forEach({
            let headerMode = self.headerDelegate?.headerMode?(forColumnAt: index)
            let font = self.headerDelegate?.fontForHeader?(forColumnAt: index)
            $0.setHeaderMode(on,headerMode,font)
            index+=1
        })
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
