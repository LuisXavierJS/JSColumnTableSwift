//
//  ColumnTableViewCell.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ColumnsTableViewCell: UITableViewCell {
    let containerView: ColumnsViewContainer = ColumnsViewContainer()
    
    fileprivate lazy var containerConstraintsToActivateOnSetup: [NSLayoutConstraint] = {
        return self.createContainerConstraintsToActivateOnSetup()
    }()
    
    func setupViews(){        
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
    
    private func setCollumnsIfNotSetted(){
        if self.containerView.columns.isEmpty && self.bounds != CGRect.zero{
            self.containerView.setColumnFields(self.fieldsToShowOnColumnsViewContainer())
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setCollumnsIfNotSetted()
    }

    func fieldsToShowOnColumnsViewContainer() -> [UIView] {
        return []
    }
}


class SpecialColumnsTableViewCell: ColumnsTableViewCell {
    let atualizar = UISwitch()
    let nome = UILabel()
    let novoNome = UITextField()
    let executar = UIButton()
    
    
}
