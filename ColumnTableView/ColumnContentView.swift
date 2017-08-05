//
//  ColumnContentView.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 04/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

enum ColumnFieldHeaderMode {
    case title
    case none
    case field
}

class ColumnFieldContent: NSObject {
    weak var field: UIView!
    var title: String
    var headerMode: ColumnFieldHeaderMode
    var preferredSizeOfField: CGSize?
    
    init(_ field: UIView, title: String, header: ColumnFieldHeaderMode,_ preferredSize: CGSize? = nil){
        self.field = field
        self.title = title
        self.headerMode = header
        self.preferredSizeOfField = preferredSize
        super.init()
    }

}

class ColumnContentView: UIView {
    private(set) var fieldContent: ColumnFieldContent!
    
    private(set) var isShowing: Bool = true
    
    private(set) var widthConstraint: NSLayoutConstraint!
    
    private(set) var showingModeWidth: CGFloat = 0
    
    private(set) weak var rightSeparator: UIView!
    
    private(set) weak var leftSeparator: UIView!
    
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
        self.clipsToBounds = false
        self.fieldContent.field.translatesAutoresizingMaskIntoConstraints = false
        let rightLine = UIView()
        let leftLine = UIView()
        
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        rightLine.backgroundColor = UIColor.black
        leftLine.backgroundColor = UIColor.black
        
        self.addSubview(rightLine)
        self.addSubview(leftLine)
        self.addSubview(self.fieldContent.field)
        
        self.rightSeparator = rightLine
        self.leftSeparator = leftLine
        
        self.setupConstraints()
    }
    
    private func setupConstraints(){
        var constraintsToActivate: [NSLayoutConstraint] = []
        constraintsToActivate.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-(s)-[view(l)]", metrics: ["s":-0.5,"l":0.5], views: ["view":self.leftSeparator]))
        constraintsToActivate.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[view(l)]-(s)-|", metrics: ["s":-0.5,"l":0.5], views: ["view":self.rightSeparator]))
        constraintsToActivate.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", metrics: nil, views: ["view":self.leftSeparator]))
        constraintsToActivate.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", metrics: nil, views: ["view":self.rightSeparator]))
        constraintsToActivate.append(contentsOf: [self.fieldContent.field.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                                  self.fieldContent.field.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
        if let size = self.fieldContent.preferredSizeOfField {
            constraintsToActivate.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[view(l@750)]", metrics: ["l":size.width], views: ["view":self.fieldContent.field]))
            constraintsToActivate.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:[view(a@750)]", metrics: ["a":size.height], views: ["view":self.fieldContent.field]))
            constraintsToActivate.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[view(<=s@1000)]", metrics: nil, views: ["view":self.fieldContent.field,"s":self]))
            constraintsToActivate.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:[view(<=s@1000)]", metrics: nil, views: ["view":self.fieldContent.field,"s":self]))
        }else{
            constraintsToActivate.append(NSLayoutConstraint(item: self.fieldContent.field,
                                                            attribute: .width,
                                                            relatedBy: .equal,
                                                            toItem: self,
                                                            attribute: .width,
                                                            multiplier: 0.9,
                                                            constant: 0))
            constraintsToActivate.append(NSLayoutConstraint(item: self.fieldContent.field,
                                                            attribute: .height,
                                                            relatedBy: .equal,
                                                            toItem: self,
                                                            attribute: .height,
                                                            multiplier: 0.9,
                                                            constant: 0))
        }
        NSLayoutConstraint.activateIfNotActive(constraintsToActivate)
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
        self.clipsToBounds = false
        self.widthConstraint.constant = self.showingModeWidth
    }
    
    func hide(){
        self.isShowing = false
        self.clipsToBounds = true
        self.widthConstraint.constant = 0
    }
    
    func setHeaderMode(_ on: Bool){
        
    }
}
