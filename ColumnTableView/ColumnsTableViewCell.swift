//
//  ColumnTableViewCell.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

protocol ColumnsViewProtocol: class {
    func hideColumns(_ columns: [Int])
    func showColumns(_ columns: [Int])
}

class ColumnsTableViewCell: UITableViewCell, ColumnsViewContainerControllerDelegate, ColumnsViewProtocol {
    let containerView: ColumnsViewContainer = ColumnsViewContainer()
    
    private lazy var containerConstraintsToActivateOnSetup: [NSLayoutConstraint] = {
        return self.createContainerConstraintsToActivateOnSetup()
    }()
        
    var columnsFields: [ColumnFieldContent] {
        return []
    }
    
    func hideColumns(_ columns: [Int]){
        self.containerView.hideColumns(columns)
    }
    
    func showColumns(_ columns: [Int]){
        self.containerView.showColumns(columns)
    }
    
    func setupViews(){
        self.containerView.delegate = self
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.setContainerConstraintsIfNeeded()
    }
    
    private func setContainerConstraintsIfNeeded(){
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
        return [ColumnFieldContent(atualizar,title: "atualizar", CGSize(width:50,height:30)),
                ColumnFieldContent(nome, title: "nome"),
                ColumnFieldContent(novoNome,title: "novoNome"),
                ColumnFieldContent(executar,title: "executar"),
                ColumnFieldContent(imagem,title:"imagem")]
    }    
    
    func redimensioningScaleForFreeSpace(forColumnAt index: Int) -> CGFloat {
        return Array<CGFloat>(arrayLiteral: 0,0.5,0.5,0,0)[index]
    }
    
    func preferredInitialFixedWidth(forColumnAt index: Int) -> CGFloat {
        return Array<CGFloat>(arrayLiteral: 60,200,200,200,50)[index]
    }
}
