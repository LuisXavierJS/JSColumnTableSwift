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
            ColumnFieldContent(nome, title: "Wat"),
            ColumnFieldContent(another, title: "Da"),
            ColumnFieldContent(executar,title: "Fok", CGSize(width:500,height:50)),
//            ColumnFieldContent(imagem,title:"imagem", CGSize(width: 100, height: 50))
        ]
    }
    
    func preferredInitialFixedWidth(forColumnAt index: Int) -> CGFloat {
        return Array<CGFloat>(arrayLiteral: 300,200,200,200,50)[index]
    }
//
    override func setupViews() {
        super.setupViews()
        self.nome.text = "COEEEEEEH"
        self.another.text = "RAPAAAZIAAADAA"
        self.executar.setTitle("COÉ RAPAZIADA", for: .normal)
        self.executar.layer.borderColor = UIColor.generateRandomColor().cgColor
        self.executar.backgroundColor = UIColor.white
        self.executar.setTitleColor(UIColor.generateRandomColor(), for: .normal)
        self.executar.layer.borderWidth = 1
        self.executar.layer.cornerRadius = 5
    }
    
    func setup(_ object: UIColor) {
        self.another.backgroundColor = object.withAlphaComponent(0.5)
        self.nome.backgroundColor = object.withAlphaComponent(0.5)
    }
}
