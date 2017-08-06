//
//  ColumnTableView.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

/*
 ATUAIS LIMITACOES DA TABELA:
 As limitacoes abaixo sao necessarias por enquanto, mas pode ser resolvido atraves da melhoria dos algoritmos de criacao e controle das constraints das colunas.
 - Ela nao funciona bem com modificacoes dinamicas de tamanho dela.. Se o dispositivo girar e isso mudar a largura dela, por exemplo, algumas constraints podem acabar quebrando, o que nao significa que necessariamente vai zoar tudo (eh comum a gente ver constraint quebrando mas sem sinais aparentes na tela.. o iOS sabe lidar bem com isso).
 - Ela precisa que uma das colunas seja considerada "principal", que nunca podera ser ocultada pelo hideColumns
 */

class ColumnsTableView: UITableView {
    
    private func setupViews(){
        
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    

}
