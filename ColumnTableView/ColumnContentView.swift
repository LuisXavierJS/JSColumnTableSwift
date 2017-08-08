//
//  ColumnContentView.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 04/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@objc public enum ColumnFieldHeaderMode: Int{
    case title = 1
    case none = 0
    case field = 2
}

open class ColumnFieldContent: NSObject {
    open weak var field: UIView!
    open let title: String
    open let preferredSizeOfField: CGSize?
    
    public init(_ field: UIView, title: String,_ preferredSize: CGSize? = nil) {
        self.field = field
        self.title = title
        self.preferredSizeOfField = preferredSize
        super.init()
    }
}

open class ColumnContentView: UIView {
    open private(set) var fieldContent: ColumnFieldContent!
    
    open private(set) var isShowing: Bool = true
    
    open private(set) var widthConstraint: NSLayoutConstraint!
    
    open private(set) var showingModeWidth: CGFloat = 0
    
    open private(set) weak var rightSeparator: UIView!
    
    open private(set) weak var leftSeparator: UIView!
    
    open private(set) var headerTitle: UILabel?
    
    open private(set) var headerMode: ColumnFieldHeaderMode = .title
    
    open var fontOfHeaderTitle: UIFont? {
        didSet{
            self.updateHeaderTitleFont()
        }
    }
    
    private lazy var headerTitleConstraints: [NSLayoutConstraint] = {
        return [self.headerTitle!.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.headerTitle!.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                NSLayoutConstraint(item: self.headerTitle!,
                                   attribute: .width,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .width,
                                   multiplier: 0.9,
                                   constant: 0)]
    }()
    
    public init(withField field: ColumnFieldContent){
        self.fieldContent = field
        super.init(frame: CGRect.zero)
        self.setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
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
        constraintsToActivate.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-(s)-[view]-(s)-|", metrics: ["s":0], views: ["view":self.leftSeparator]))
        constraintsToActivate.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-(s)-[view]-(s)-|", metrics: ["s":0], views: ["view":self.rightSeparator]))
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
 
    private func createHeaderTitle(){
        let label = UILabel()
        self.headerTitle = label
        self.headerTitle?.translatesAutoresizingMaskIntoConstraints = false
        self.headerTitle?.adjustsFontSizeToFitWidth = true
        self.headerTitle?.text = self.fieldContent.title
        self.updateHeaderTitleFont()
    }
    
    private func updateHeaderTitleFont(){
        if let font = self.fontOfHeaderTitle {
            self.headerTitle?.font = font
        }
    }
    
    private func setFieldVisibility(showing: Bool){
        self.fieldContent.field.isUserInteractionEnabled = showing
        self.fieldContent.field.isOpaque = showing
        self.fieldContent.field.isHidden = !showing
    }
    
    private func showHeader(){
        switch self.headerMode {
        case .title:
            if let headerTitle = self.headerTitle{
                self.addSubview(headerTitle)
                NSLayoutConstraint.activateIfNotActive(self.headerTitleConstraints)
            }else{
                self.setFieldVisibility(showing: false)
                self.createHeaderTitle()
                self.showHeader()
            }
            break
        case .none:
            self.setFieldVisibility(showing: false)
            break
        case .field:
            self.setFieldVisibility(showing: true)
            break
        }
    }
    
    private func hideHeader(){
        if let headerTitle = self.headerTitle{
            NSLayoutConstraint.deactivate(self.headerTitleConstraints)
            headerTitle.removeFromSuperview()
        }else{
            self.setFieldVisibility(showing: true)
        }
    }
    
    open func setWidth(constraint: NSLayoutConstraint){
        if let actualWidthConstraint = self.widthConstraint{
            NSLayoutConstraint.deactivate([actualWidthConstraint])
        }
        self.widthConstraint = constraint
        self.widthConstraint.identifier = self.fieldContent.title
        self.showingModeWidth = self.widthConstraint.constant
    }
    
    open func updateShowingModeWidth(_ width: CGFloat){
        self.showingModeWidth = width
        if self.isShowing {
            self.widthConstraint.constant = self.showingModeWidth
        }
    }
    
    open func show(){
        self.isShowing = true
        self.clipsToBounds = false
        self.alpha = 1
        self.widthConstraint.constant = self.showingModeWidth
    }
    
    open func hide(){
        self.isShowing = false
        self.clipsToBounds = true
        self.alpha = 0
        self.widthConstraint.constant = 0
    }
    
    open func setHeaderMode(_ on: Bool, _ mode: ColumnFieldHeaderMode?, _ font: UIFont? = nil){
        self.fontOfHeaderTitle = font
        self.headerMode = mode ?? .title
        if on {
            self.showHeader()
        }else{
            self.hideHeader()
        }
    }
}
