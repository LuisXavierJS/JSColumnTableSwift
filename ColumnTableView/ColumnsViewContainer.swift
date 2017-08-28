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
}

@objc public protocol ColumnHeaderControllerDelegate: class {
//  Informa qual a fonte utilizada para o titulo do label de cabecalho de uma determinada coluna
// - Se nao for implementado, utiliza a font padrao de um label
    @objc optional func fontForHeader(forColumnAt index: Int) -> UIFont
    
//  Informa o tipo de cabecalho para uma determinada coluna (Se vai ser um label de titulo, o proprio campo ou nada)
// - Se nao for implementado, utiliza o default (label de titulo)
    @objc optional func headerMode(forColumnAt index: Int) -> ColumnFieldHeaderMode
}

open class ColumnsViewContainer: UIView {
    open private(set) weak var mainColumn: ColumnContentView?
    open private(set) var columns: [ColumnContentView] = []
    
    private lazy var spaceVariations: [CGFloat] = {
        return (0..<self.columns.count).map({_ in CGFloat(0)})
    }()
    
    open weak var delegate: ColumnsViewContainerControllerDelegate?
    open weak var headerDelegate: ColumnHeaderControllerDelegate?
    
    open var normalModeBackgroundColor: UIColor = UIColor.clear
    open var headerModeBackgroundColor: UIColor = UIColor.lightGray
    
    //Calculando as definicoes de comprimento calculados (com base na sugestao do delegate) e sugeridos pelo delegate (o delegate pode sugerir muita merda haha) de cada coluna.
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
    
    //Calculando a distribuicao de espaco livre na linha para todas as colunas visiveis (nessa hora que o delegate pode informar prioridades erradas e bugar a visualizacao do esquema..)
    private func redistributeSpaceOfColumns(forSpaceVariation space: CGFloat){
        var totalSpace: CGFloat = 0
        for columnIndex in 0..<self.columns.count {
            self.spaceVariations[columnIndex] = 0
            if self.columns[columnIndex].isShowing {
                if let priorityForColumn = self.delegate?.redimensioningScaleForFreeSpace?(forColumnAt: columnIndex),
                    priorityForColumn >= 0 && priorityForColumn <= 1 && totalSpace < space{
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
    
    //Calculando o espaco livre de uma linha.
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
    
    //Atualizando o comprimento das colunas para se comportar de acordo com o layout atual da tabela.
    private func updateColumnsWidthConstraints(){
        let widthDefinitions = self.getWidthDefinitionsOfColumns()
        self.redistributeSpaceOfColumns(forSpaceVariation: self.calculateSpaceVariation())
        widthDefinitions.forEach { (columnIndex,width,_) in
            self.columns[columnIndex].updateShowingModeWidth(width+self.spaceVariations[columnIndex])
        }
    }
    
    //Configurando todas as colunas, e escondendo as desejadas pelo delegate.
    private func setupAllColumns(){
        if self.columns.count > 0 {
            self.columns.forEach({self.addSubview($0)})
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
        guard let headerDelegate = self.headerDelegate else {return}
        self.backgroundColor = on ? self.headerModeBackgroundColor : self.normalModeBackgroundColor
        var index: Int = 0
        self.columns.forEach({
            let headerMode = headerDelegate.headerMode?(forColumnAt: index)
            let font = headerDelegate.fontForHeader?(forColumnAt: index)
            $0.setHeaderMode(on,headerMode,font)
            index+=1
        })
    }
    
    //Configura todas as colunas assim que possui uma superview (desta forma, podendo configurar as constraints corretamente)
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let delegate = self.delegate{
            self.setColumnFields(delegate.columnsFields)
        }
    }
    
    //Atualiza o comprimento das constraints conforme o layout atual da tabela.
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updateColumnsWidthConstraints()
    }

}
