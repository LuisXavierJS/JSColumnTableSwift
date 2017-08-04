//
//  ColumnContentView.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 04/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ColumnContentView: UIView {
    private(set) var fieldContent: UIView!
    
    private var widthConstraint: NSLayoutConstraint!
    
    var showingModeWidth: CGFloat = 0
    
    init(withField field: UIView){
        self.fieldContent = field
        super.init(frame: CGRect.zero)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    private func setupViews(){
        
    }
 
    func setWidth(constraint: NSLayoutConstraint){
        if let actualWidthConstraint = self.widthConstraint{
            NSLayoutConstraint.deactivate([actualWidthConstraint])
        }
        self.widthConstraint = constraint
        self.showingModeWidth = self.widthConstraint.constant
    }
    
    func show(){
        self.widthConstraint.constant = self.showingModeWidth
    }
    
    func hide(){
        self.widthConstraint.constant = 0
    }
}
