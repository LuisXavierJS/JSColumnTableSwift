//
//  ColumnContentView.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 04/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ColumnFieldContent: NSObject {
    weak var field: UIView!
    var title: String
    var preferredSize: CGSize?
    var redimensioningPriority: CGFloat?
    
    init(_ field: UIView, title: String){
        self.field = field
        self.title = title
        super.init()
    }
}

class ColumnContentView: UIView {
    private(set) var fieldContent: ColumnFieldContent!
    
    private(set) var isShowing: Bool = true
    
    private(set) var widthConstraint: NSLayoutConstraint!
    
    private(set) var showingModeWidth: CGFloat = 0
    
    init(withField field: ColumnFieldContent){
        self.fieldContent = field
        super.init(frame: CGRect.zero)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    private func setupViews(){
        self.translatesAutoresizingMaskIntoConstraints = false
    }
 
    func setWidth(constraint: NSLayoutConstraint){
        if let actualWidthConstraint = self.widthConstraint{
            NSLayoutConstraint.deactivate([actualWidthConstraint])
        }
        self.widthConstraint = constraint
        self.widthConstraint.identifier = self.fieldContent.title
        self.showingModeWidth = self.widthConstraint.constant
    }
    
    func updateShowingModeWidth(_ width: CGFloat){
        self.showingModeWidth = width
        if self.isShowing {
            self.widthConstraint.constant = self.showingModeWidth
        }
    }
    
    func show(){
        self.isShowing = true
        self.widthConstraint.constant = self.showingModeWidth
    }
    
    func hide(){
        self.isShowing = false
        self.widthConstraint.constant = 0
    }
}
