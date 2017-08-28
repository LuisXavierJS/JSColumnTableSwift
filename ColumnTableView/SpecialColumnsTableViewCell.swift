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
//    let atualizar = UISwitch()
    let nome = UILabel()
    let another = UILabel()
    let executar = UIButton()
//    let imagem = UIImageView()
    
    override var columnsFields: [ColumnFieldContent] {
        return [
//            ColumnFieldContent(atualizar,title: "atualizar", CGSize(width:50,height:30)),
            ColumnFieldContent(nome, title: "nome"),
            ColumnFieldContent(another, title: "nome"),
            ColumnFieldContent(executar,title: "executar", CGSize(width:200,height:50)),
//            ColumnFieldContent(imagem,title:"imagem", CGSize(width: 100, height: 50))
        ]
    }
    
//    func preferredInitialFixedWidth(forColumnAt index: Int) -> CGFloat {
//        return Array<CGFloat>(arrayLiteral: 400,200,200,200,50)[index]
//    }
//    
    override func setupViews() {
        super.setupViews()
//        self.nome.backgroundColor = UIColor.green
//        self.another.backgroundColor = UIColor.blue
//        self.executar.backgroundColor = UIColor.cyan
        self.nome.text = "RAPAAAZIAAADAA"
        self.another.text = "COEEEEEEH"
        self.executar.setTitle("COÉ RAPAZIADA", for: .normal)
        self.executar.layer.borderColor = UIColor.generateRandomColor().cgColor
        self.executar.backgroundColor = UIColor.white
        self.executar.setTitleColor(UIColor.generateRandomColor(), for: .normal)
        self.executar.layer.borderWidth = 1
        self.executar.layer.cornerRadius = 5
//        self.imagem.backgroundColor = UIColor.magenta
    }
    
    func setup(_ object: UIColor) {
//        self.contentView.backgroundColor = object
    }
}
