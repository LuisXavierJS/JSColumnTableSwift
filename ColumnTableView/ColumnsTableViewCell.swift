//
//  ColumnTableViewCell.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ColumnsTableViewCell: UITableViewCell, ColumnsViewContainerController {
    let containerView: ColumnsViewContainer = ColumnsViewContainer()
    
    private lazy var containerConstraintsToActivateOnSetup: [NSLayoutConstraint] = {
        return self.createContainerConstraintsToActivateOnSetup()
    }()
    
    var columnsFields: [ColumnFieldContent] {
        return []
    }
    
    func setupViews(){
        self.containerView.delegate = self
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(containerView)
        
        NSLayoutConstraint.activateIfNotActive(self.containerConstraintsToActivateOnSetup)
    }
    
    func createContainerConstraintsToActivateOnSetup() -> [NSLayoutConstraint] {
        var containerConstraints: [NSLayoutConstraint] = []
        containerConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", metrics: nil, views: ["container":self.containerView]))
        containerConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[container]|", metrics: nil, views: ["container":self.containerView]))
        return containerConstraints
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
}


class SpecialColumnsTableViewCell: ColumnsTableViewCell {
    let atualizar = UISwitch()
    let nome = UILabel()
    let novoNome = UITextField()
    let executar = UIButton()
    let imagem = UIImageView()
    
    override var columnsFields: [ColumnFieldContent] {
        return [ColumnFieldContent(atualizar,title: "atualizar"),
                ColumnFieldContent(nome, title: "nome"),
                ColumnFieldContent(novoNome,title: "novoNome"),
                ColumnFieldContent(executar,title: "executar"),
                ColumnFieldContent(imagem,title:"imagem")]
    }
    
}
