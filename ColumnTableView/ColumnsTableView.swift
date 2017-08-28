//
//  ColumnTableView.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

/*
 Perdi um tempao nessa desgraca de solucao.. apanhei bastante pras constraints programaticas e pros calculos das paradas, mas mesmo assim ficou imperfeito e defeituoso em alguns casos (apesar de ja resolver o problema de colunas).
 Ainda preciso de tempo pra reavaliar e melhorar o codigo e a logica..
 
 ATUAIS LIMITACOES DA TABELA:
 As limitacoes abaixo sao necessarias por enquanto, mas pode ser resolvido atraves da melhoria dos algoritmos de criacao e controle das constraints das colunas.
 - Ela nao funciona bem com modificacoes dinamicas de tamanho dela.. Se o dispositivo girar e isso mudar a largura dela, por exemplo, algumas constraints podem acabar quebrando, o que nao significa que necessariamente vai zoar tudo (eh comum a gente ver constraint quebrando mas sem sinais aparentes na tela.. o iOS sabe lidar bem com isso).
 - Ela precisa que uma das colunas seja considerada "principal", que ira ocupar espacos que podem sobrar na tabela caso ocorra algum conflito de espaco entre as colunas e a linha.
 - A tabela nao esta lidando bem com altura dinamica das linhas (com label de multilinhas, por exemplo).
 */

@objc public protocol TableColumnsVisibilityControllerDelegate: class {
    func hideColumns(forTable: ColumnsTableView) -> [Int]
}

open class ColumnsTableView: UITableView {
    var cellInstanceForCalculations: ColumnsTableViewCell?
    
    open weak var columnsControllerDelegate: TableColumnsVisibilityControllerDelegate?
    
    private func setColumnsVisibility(forColumnsView view: UIView?){
        if let columnsView = view as? ColumnsViewProtocol,
            let columnsToHide = self.columnsControllerDelegate?.hideColumns(forTable: self){
            columnsView.hideColumns(columnsToHide)
        }
    }
    
    open override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        let cell = super.dequeueReusableCell(withIdentifier: identifier)
        self.setColumnsVisibility(forColumnsView: cell)
        return cell
    }
    
    open override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        let cell = super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        self.setColumnsVisibility(forColumnsView: cell)
        return cell
    }
    
    open override func dequeueReusableHeaderFooterView(withIdentifier identifier: String) -> UITableViewHeaderFooterView? {
        let header = super.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        self.setColumnsVisibility(forColumnsView: header)
        return header
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.cellInstanceForCalculations?.layoutSubviews()
    }

}
