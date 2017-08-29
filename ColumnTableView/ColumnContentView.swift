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
    weak var cachedColumn: ColumnContentView?
    
    private var lastLayoutedBounds: CGRect = CGRect.zero
    
    open var rightSeparatorLineWidth: CGFloat = 1
    
    open var leftSeparatorLineWidth: CGFloat = 1
    
    open var applyCustomSettingsToField: ((UIView)->Void) = ColumnContentView.applyCustomSettings
    
    open var fieldFixedRepositioningInsets: UIEdgeInsets?
    
    open var fieldRelativeRepositioningInsets: UIEdgeInsets = UIEdgeInsetsMake(0.1, 0.05, 0.1, 0.05)
    
    open var rightSeparatorFrameAlignments: [CGRectAlignment] = [.right(addendum:0.5)]
    
    open var leftSeparatorFrameAlignments: [CGRectAlignment] = [.left(addendum:-0.5)]
    
    open var fieldFrameAlignments: [CGRectAlignment] = [.horizontallyCentralized(addendum: 0), .verticallyCentralized(addendum:0)]
    
    open private(set) var fieldContent: ColumnFieldContent?
    
    open private(set) var isShowing: Bool = true
    
    open private(set) var showingModeWidth: CGFloat = 0
    
    open private(set) var rightSeparator: RightSeparationLineView = RightSeparationLineView()
    
    open private(set) var leftSeparator: LeftSeparationLineView = LeftSeparationLineView()
    
    open private(set) var headerTitle: UILabel?
    
    open private(set) var headerMode: ColumnFieldHeaderMode = .title    
    
    deinit {
        self.rightSeparator.removeFromSuperview()
        self.leftSeparator.removeFromSuperview()
        self.fieldContent?.field?.removeFromSuperview()
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
        
        rightSeparator.backgroundColor = UIColor.black
        leftSeparator.backgroundColor = UIColor.black
        
        self.addSubview(leftSeparator)
        if let field = self.fieldContent?.field {
            self.addSubview(field)
        }
        self.addSubview(rightSeparator)
    }
    
    private func createHeaderTitle(){
        let label = UILabel()
        self.headerTitle = label
        self.headerTitle?.adjustsFontSizeToFitWidth = true
        self.headerTitle?.text = self.fieldContent?.title
    }

    private func setFieldVisibility(showing: Bool){
        self.fieldContent?.field?.isUserInteractionEnabled = showing
        self.fieldContent?.field?.isOpaque = showing
        self.fieldContent?.field?.isHidden = !showing
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
    
    open func setHeaderMode(_ on: Bool, _ mode: ColumnFieldHeaderMode?){
        self.headerMode = mode ?? .title
        if on {
            self.showHeader()
        }else{
            self.hideHeader()
        }
    }
    
    //Atualizando o comprimento das colunas para se comportar de acordo com o layout atual da tabela.
    func calculateSubviewsFrames(for base: CGRect){
        if let cached = self.cachedColumn {
            
            self.headerTitle?.frame = cached.headerTitle?.frame ?? self.bounds.insetBy(dx: 5, dy: 5)
            self.rightSeparator.frame = cached.rightSeparator.frame
            self.leftSeparator.frame = cached.leftSeparator.frame
            
            self.fieldContent?.field.frame = cached.fieldContent?.field.frame ?? CGRect.zero
            if let field = self.fieldContent?.field {
                self.applyCustomSettingsToField(field)
            }
            
        }else {
            if let size = self.fieldContent?.preferredSizeOfField {
                self.fieldContent?.field?.frame.size = size.limitedTo(base.size)
            }else{
                self.fieldContent?.field?.frame.size = base.size
            }
            
            if let field = self.fieldContent?.field {
                self.applyCustomSettingsToField(field)
            }
            
            self.headerTitle?.frame = self.bounds.insetBy(dx: 5, dy: 5)
            if let field = self.fieldContent?.field {
                field.frame = field.frame.aligned(self.fieldFrameAlignments, in: base)
            }
            self.rightSeparator.frame = self.bounds.with(width: self.rightSeparatorLineWidth).aligned(self.rightSeparatorFrameAlignments, in: self.bounds)
            self.leftSeparator.frame = self.bounds.with(width: self.leftSeparatorLineWidth).aligned(self.leftSeparatorFrameAlignments, in: self.bounds)
        }
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
                                       right: self.bounds.width*insets.right * 2,
                                       top: self.bounds.height*insets.top,
                                       bottom: self.bounds.height*insets.bottom * 2)
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
        if let label = field as? UILabel, label.numberOfLines != 1{
            label.frame.size = label.sizeThatFits(CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        }
    }
}
