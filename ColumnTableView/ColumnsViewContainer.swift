//
//  ColumnsViewContainer.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


@objc public protocol ColumnsViewContainerControllerDelegate: class {
    var columnsFields: [ColumnFieldContent] {get}
    
//  Informa coluna que preferencialmente tera seu tamanho variavel conforme a variacao de tamanho da superview e das demais colunas
// - Se nao for implementado, o default sera assumido como a coluna de maior tamanho na tabela.
    @objc optional var mainColumnIndex: Int {get}
    
//  Informa a prioridade para ajuste de comprimento de uma determinada coluna, caso outra coluna seja ocultada ou exibida no container.
// - Se nao for implementado, a prioridade de redimensionamento sera igual para todas as colunas
    @objc optional func redimensioningScaleForFreeSpace(forColumnAt index: Int) -> CGFloat
    
//  Informa a preferencia de largura inicial para uma coluna durante o layout:
// -  Se nao for implementado, a preferencia de largura inicial sera igual para todas as colunas.
// -  Se for implementado mas retornar valores que nao representem o real tamanho da ColumnsViewCell, as colunas finais podem desaparecer ou a mainColumn pode aumentar para compensar a diferenca de tamanho.
    @objc optional func preferredInitialFixedWidth(forColumnAt index: Int) -> CGFloat
    
//  Informa a preferencia de largura inicial para uma coluna durante o layout:
// -  Se nao for implementado, a preferencia de largura inicial sera igual para todas as colunas.
// -  Se for implementado mas retornar valores que nao representem o real tamanho da ColumnsViewCell, as colunas finais podem desaparecer ou a mainColumn pode aumentar para compensar a diferenca de tamanho.
    @objc optional func preferredRelativeWidth(forColumnAt index: Int) -> CGFloat
    
    //  Pede para o delegate configurar o label a ser exibido no header
    @objc optional func applySettingsOn(headearLabel label: UILabel?, forColumnAt index: Int)
    
    //  Informa o tipo de cabecalho para uma determinada coluna (Se vai ser um label de titulo, o proprio campo ou nada)
    // - Se nao for implementado, utiliza o default (label de titulo)
    @objc optional func headerMode(forColumnAt index: Int) -> ColumnFieldHeaderMode
}

open class ColumnsViewContainer: UIView {
    private var lastLayoutedBounds: CGRect = CGRect.zero

    
    open private(set) weak var mainColumn: ColumnContentView?
    open private(set) var columns: [ColumnContentView] = []
    
    private lazy var spaceVariations: [CGFloat] = {
        return (0..<self.columns.count).map({_ in CGFloat(0)})
    }()
    
    open weak var delegate: ColumnsViewContainerControllerDelegate?
    
    open var normalModeBackgroundColor: UIColor = UIColor.clear
    open var headerModeBackgroundColor: UIColor = UIColor.lightGray
    
    //Calculando as definicoes de comprimento calculados (com base na sugestao do delegate) e sugeridos pelo delegate (o delegate pode sugerir muita merda haha) de cada coluna.
    //Default base = self.bounds
    private func getWidthDefinitionsOfColumns(for base: CGRect) -> [(column: Int, calculatedWidth: CGFloat, preferredWidth: CGFloat)]{
        let defaultColumnWidth = base.width/CGFloat(self.columns.count)
        
        var widthDefinitions: [(column: Int, calculatedWidth: CGFloat, preferredWidth: CGFloat)] = []
        var totalColumnsWidth: CGFloat = 0
        
        self.columns.enumerated().forEach { (index,column) in
            let widthLimitOfColumn = max(base.width - totalColumnsWidth,0)
            var calculatedWidth: CGFloat = defaultColumnWidth
            var preferredWidth: CGFloat = defaultColumnWidth
            
            if let preferredRelativeWidth = self.delegate?.preferredRelativeWidth?(forColumnAt: index){
                preferredWidth = preferredRelativeWidth
                calculatedWidth = min(base.width * preferredWidth,widthLimitOfColumn)
            }
            else if let preferredFixedWidth = self.delegate?.preferredInitialFixedWidth?(forColumnAt: index){
                preferredWidth = preferredFixedWidth
                calculatedWidth =  min(preferredWidth,widthLimitOfColumn)
            }
            
            widthDefinitions.append((column: index, calculatedWidth: calculatedWidth, preferredWidth: preferredWidth))
            totalColumnsWidth+=calculatedWidth
        }
        
        if totalColumnsWidth != base.width {
            //adjust definitions to fit base.width
            let mainColumnIndex = self.delegate?.mainColumnIndex  ?? widthDefinitions.sorted(by: {$0.preferredWidth > $1.preferredWidth}).first?.column ?? 0
            let totalSizeWithoutMainColumn: CGFloat = totalColumnsWidth - widthDefinitions[mainColumnIndex].calculatedWidth
            widthDefinitions[mainColumnIndex].calculatedWidth = base.width - totalSizeWithoutMainColumn
        }

        return widthDefinitions
    }
    
    //Calculando a distribuicao de espaco livre na linha para todas as colunas visiveis (nessa hora que o delegate pode informar prioridades erradas e bugar a visualizacao do esquema..)
    private func redistributeSpaceOfColumns(forSpaceVariation space: CGFloat){
        var totalSpace: CGFloat = 0
        let showingColumnsNumber = (self.columns.filter({$0.isShowing}).count)
        self.columns.enumerated().forEach { (columnIndex,column) in
            self.spaceVariations[columnIndex] = 0
            if self.columns[columnIndex].isShowing {
                if let priorityForColumn = self.delegate?.redimensioningScaleForFreeSpace?(forColumnAt: columnIndex),
                    priorityForColumn >= 0 && priorityForColumn <= 1 && totalSpace < space{
                    let variation = space * priorityForColumn
                    totalSpace+=variation
                    self.spaceVariations[columnIndex]+=variation
                }else{
                    let variation = (space * (1/CGFloat(showingColumnsNumber)))
                    if variation + totalSpace >= space {
                        self.spaceVariations[columnIndex]+=(space - totalSpace)
                    }else{
                        self.spaceVariations[columnIndex]+=variation
                    }
                }
            }
        }
    }
    
    //Calculando o espaco livre de uma linha.
    private func calculateSpaceVariation(for base: CGRect) -> CGFloat{
        var spaceVariation: CGFloat = 0
        self.columns.filter({!$0.isShowing}).forEach({spaceVariation+=$0.showingModeWidth})
        if spaceVariation == 0 {
            self.getWidthDefinitionsOfColumns(for: base).forEach({ (columnIndex,width,_) in
                if !self.columns[columnIndex].isShowing {
                    spaceVariation+=width
                }
            })
        }
        return spaceVariation
    }
    
    //Configurando todas as colunas, e escondendo as desejadas pelo delegate.
    private func setupAllColumns(){
        if self.columns.count > 0 {
            self.columns.forEach({
                self.addSubview($0)
                $0.backgroundColor = UIColor.clear
            })
        }
    }
    
    //Resetando as colunas atuais e atribuindo novas colunas.
    private func setColumnFields(_ columns: [ColumnFieldContent]) {
        self.columns = columns.map({return ColumnContentView(withField: $0)})
        self.setupAllColumns()
    }
    
    //Exibe as colunas que estavam escondidas anteriormente e esconde as colunas passadas por parametro
    open func hideColumns(_ columns: [Int]) {
        if columns.count > 0 {
            let columnsToShow = Array<Int>(0..<self.columns.count).filter({!columns.contains($0) && !self.columns[$0].isShowing})
            self.showColumns(columnsToShow)
            columns.forEach({self.columns[$0].hide()})
        }
    }
    
    //Exibe as colunas passadas por parametro
    open func showColumns(_ columns: [Int]) {
        columns.forEach({self.columns[$0].show()})
    }
    
    //Ativa o modo de cabecalho das colunas
    open func setHeaderMode(_ on: Bool){
        guard let headerDelegate = self.delegate else {return}
        self.backgroundColor = on ? self.headerModeBackgroundColor : self.normalModeBackgroundColor
        self.columns.enumerated().forEach({ (index, column) in
            let headerMode = headerDelegate.headerMode?(forColumnAt: index)
            column.setHeaderMode(on,headerMode)
            headerDelegate.applySettingsOn?(headearLabel: column.headerTitle, forColumnAt: index)
        })
    }
    
    //Configura todas as colunas assim que possui uma superview (desta forma, podendo configurar as constraints corretamente)
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let delegate = self.delegate{
            self.setColumnFields(delegate.columnsFields)
        }
    }
    
    //Atualizando o comprimento das colunas para se comportar de acordo com o layout atual da tabela.
    func calculateSubviewsFrames(for base: CGRect){
        let widthDefinitions = self.getWidthDefinitionsOfColumns(for: base)

        self.redistributeSpaceOfColumns(forSpaceVariation: self.calculateSpaceVariation(for: base))
        
        func lastColumnMaxX(current index: Int) -> CGFloat {
            return index > 0 ? self.columns[index - 1].frame.maxX : 0
        }
        
        func columnWidth(withCalculated width: CGFloat, _ index: Int) -> CGFloat {
            return index > 0 ? width+self.spaceVariations[index] : width+self.spaceVariations[index]
        }
        
        widthDefinitions.forEach { (columnIndex,width,_) in
            print(self.columns[columnIndex].frame)
            self.columns[columnIndex].updateShowingModeWidth(columnWidth(withCalculated: width,columnIndex))
            self.columns[columnIndex].frame = self.columns[columnIndex].frame
                .with(x: lastColumnMaxX(current: columnIndex))
                .with(height: self.bounds.height)
            print(self.columns[columnIndex].frame)
        }
    }
    
    func baseSubviewsArea() -> CGRect {
        return self.bounds
    }
    
    //Atualiza o comprimento das constraints conforme o layout atual da tabela.
    open override func layoutSubviews() {
        super.layoutSubviews()
//        if self.lastLayoutedBounds != self.bounds {
            self.calculateSubviewsFrames(for: self.baseSubviewsArea())
//        }
        self.lastLayoutedBounds = self.bounds
    }

}
