//
//  Cell.swift
//  ColumnTableView
//
//  Created by Anderson Lucas C. Ramos on 08/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class SpecialColumnsTableViewCell: ColumnsTableViewCell, JSSetupableCellProtocol {
    typealias DataType = UIColor
    let atualizar = UISwitch()
    let nome = UILabel()
    let novoNome = UITextField()
    let executar = UIButton()
    let imagem = UIImageView()
    
    override var columnsFields: [ColumnFieldContent] {
        return [ColumnFieldContent(atualizar,title: "atualizar", CGSize(width:50,height:30)),
                ColumnFieldContent(nome, title: "nome"),
                ColumnFieldContent(novoNome,title: "novoNome", CGSize(width:200,height:30)),
                ColumnFieldContent(executar,title: "executar", CGSize(width:200,height:50)),
                ColumnFieldContent(imagem,title:"imagem", CGSize(width: 100, height: 50))]
    }
    
    func redimensioningScaleForFreeSpace(forColumnAt index: Int) -> CGFloat {
        return Array<CGFloat>(arrayLiteral: 0,0.5,0.5,0,0)[index]
    }
    
    func preferredInitialFixedWidth(forColumnAt index: Int) -> CGFloat {
        return Array<CGFloat>(arrayLiteral: 60,200,200,200,50)[index]
    }
    
    override func setupViews() {
        super.setupViews()
        self.nome.numberOfLines = 0
        self.nome.lineBreakMode = .byWordWrapping
        self.novoNome.backgroundColor = UIColor.blue
        self.executar.backgroundColor = UIColor.cyan
        self.imagem.backgroundColor = UIColor.magenta
    }
    
    func setup(_ object: UIColor) {
        self.contentView.backgroundColor = object
    }
}
