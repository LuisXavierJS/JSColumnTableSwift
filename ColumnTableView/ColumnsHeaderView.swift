//
//  ColumnsHeaderView.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ColumnsHeaderView: UITableViewHeaderFooterView {
    
    let containerView: ColumnsViewContainer = ColumnsViewContainer()
    
    fileprivate var viewsAreSettedUp: Bool = false
    
    fileprivate lazy var containerConstraintsToActivateOnSetup: [NSLayoutConstraint] = {
        return self.createContainerConstraintsToActivateOnSetup()
    }()
    
    func setupViews(){
        if self.viewsAreSettedUp { return }
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(containerView)
        
        NSLayoutConstraint.activateIfNotActive(self.containerConstraintsToActivateOnSetup)
    }
    
    func createContainerConstraintsToActivateOnSetup() -> [NSLayoutConstraint] {
        var containerConstraints: [NSLayoutConstraint] = []
        containerConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", metrics: nil, views: ["container":self.containerView]))
        containerConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[container]|", metrics: nil, views: ["container":self.containerView]))
        return containerConstraints
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupViews()
        self.viewsAreSettedUp = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
        self.viewsAreSettedUp = true
    }

}
