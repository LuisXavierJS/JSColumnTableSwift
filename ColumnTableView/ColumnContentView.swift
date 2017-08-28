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
        self.clipsToBounds = false
        let rightLine = UIView()
        let leftLine = UIView()
        
        rightLine.backgroundColor = UIColor.black
        leftLine.backgroundColor = UIColor.black
        
        self.addSubview(rightLine)
        self.addSubview(leftLine)
        self.addSubview(self.fieldContent.field)
        
        self.rightSeparator = rightLine
        self.leftSeparator = leftLine
    }
    
    private func createHeaderTitle(){
        let label = UILabel()
        self.headerTitle = label
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
            headerTitle.removeFromSuperview()
        }else{
            self.setFieldVisibility(showing: true)
        }
    }
    
    open func updateShowingModeWidth(_ width: CGFloat){
        self.showingModeWidth = width
        if self.isShowing {

        }
    }
    
    open func show(){
        self.isShowing = true
        self.clipsToBounds = false
        self.alpha = 1
    }
    
    open func hide(){
        self.isShowing = false
        self.clipsToBounds = true
        self.alpha = 0
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
