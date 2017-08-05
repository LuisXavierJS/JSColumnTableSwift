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
        
        self.setContainerConstraints()
    }
    
    private func setContainerConstraints(){
        let needsSetConstraints = self.reuseIdentifier != nil
        
        if needsSetConstraints{
            self.contentView.addSubview(self.containerView)
            
            NSLayoutConstraint.activateIfNotActive(self.containerConstraintsToActivateOnSetup)
        }
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
        return [ColumnFieldContent(atualizar,title: "atualizar", header: .title, CGSize(width:50,height:30)),
                ColumnFieldContent(nome, title: "nome", header: .title),
                ColumnFieldContent(novoNome,title: "novoNome", header: .title),
                ColumnFieldContent(executar,title: "executar", header: .title),
                ColumnFieldContent(imagem,title:"imagem", header: .title)]
    }

    var columnSizes: [CGFloat] = [0.1,0.3,0.2,0.3,0.1]
    
    func preferredRelativeWidthForColumn(at index: Int) -> CGFloat {
        return columnSizes[index]
    }
}
