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

open class RightSeparationLineView: UIView {}
open class LeftSeparationLineView: UIView {}


open class ColumnContentView: UIView {
    private var lastLayoutedBounds: CGRect = CGRect.zero
    
    open private(set) var fieldContent: ColumnFieldContent!
    
    open var customSettingsToField: ((UIView)->Void) = ColumnContentView.applyCustomSettings
    
    open var fieldFixedRepositioningInsets: UIEdgeInsets?
    
    open var fieldRelativeRepositioningInsets: UIEdgeInsets = UIEdgeInsetsMake(0.025, 0.025, 0.025, 0.025)
    
    open var fieldFrameAlignments: [CGRectAlignment] = [.horizontallyCentralized(addendum: 0), .verticallyCentralized(addendum:0)]
    
    open private(set) var isShowing: Bool = true
    
    open private(set) var showingModeWidth: CGFloat = 0
    
    open private(set) weak var rightSeparator: RightSeparationLineView!
    
    open private(set) weak var leftSeparator: LeftSeparationLineView!
    
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
        let rightLine = RightSeparationLineView()
        let leftLine = LeftSeparationLineView()
        
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
            self.frame = self.frame.with(width: width)
            self.setNeedsLayout()
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
    
    //Atualizando o comprimento das colunas para se comportar de acordo com o layout atual da tabela.
    func calculateSubviewsFrames(for base: CGRect){
        if let size = self.fieldContent.preferredSizeOfField {
            self.fieldContent.field.frame.size = size
        }else{
            self.fieldContent.field.frame.size = base.size
        }
        self.customSettingsToField(self.fieldContent.field)
        self.fieldContent.field.frame = self.fieldContent.field.frame.aligned(self.fieldFrameAlignments, in: base)
    }
    
    func baseSubviewsArea() -> CGRect {
        if let insets = self.fieldFixedRepositioningInsets {
            return self.bounds.insetBy(left: insets.left,
                                       right: insets.right,
                                       top: insets.top,
                                       bottom: insets.bottom)
        }else {
            let insets = self.fieldRelativeRepositioningInsets
            return self.bounds.insetBy(left: self.bounds.width*insets.left,
                                       right: self.bounds.width*insets.right,
                                       top: self.bounds.height*insets.top,
                                       bottom: self.bounds.height*insets.bottom)
        }
    }
    
    //Atualiza o comprimento das constraints conforme o layout atual da tabela.
    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.lastLayoutedBounds != self.bounds {
            self.calculateSubviewsFrames(for: self.baseSubviewsArea())
        }
        self.lastLayoutedBounds = self.bounds
    }
    
    static func applyCustomSettings(_ field: UIView){
        if let label = field as? UILabel, label.numberOfLines == 0 {
            label.frame.size = label.sizeThatFits(CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        }
    }
}
