//
//  ColumnTableViewCell.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 03/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

public protocol ColumnsViewProtocol: class {
    func hideColumns(_ columns: [Int])
    func showColumns(_ columns: [Int])
    func setCachedMirrorCellForCalculations(mirrorCell: ColumnsTableViewCell?)
}

open class ColumnsTableViewCell: UITableViewCell, ColumnsViewContainerControllerDelegate, ColumnsViewProtocol {
    weak private var cachedMirrorCell: ColumnsTableViewCell?
    
    private var lastLayoutedBounds: CGRect = CGRect.zero

    open let containerView: ColumnsViewContainer = ColumnsViewContainer()
    
    open var columnsFields: [ColumnFieldContent] {
        return []
    }
    
    open func hideColumns(_ columns: [Int]){
        self.containerView.hideColumns(columns)
    }
    
    open func showColumns(_ columns: [Int]){
        self.containerView.showColumns(columns)
    }
    
    open func setupViews(){
        self.containerView.delegate = self
        self.contentView.addSubview(containerView)
    }
   
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    func setCachedMirrorCellForCalculations(mirrorCell: ColumnsTableViewCell?) {
        self.cachedMirrorCell = mirrorCell
    }
    
    func getCachedMirrorCellForCalculations() -> ColumnsTableViewCell? {
        return self.cachedMirrorCell
    }
    
    func calculateSubviewsFrames(for base: CGRect){
        self.containerView.frame = base
    }
    
    func baseSubviewsArea() -> CGRect {
        return self.bounds
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.lastLayoutedBounds != self.bounds {
            self.calculateSubviewsFrames(for: self.baseSubviewsArea())
        }
        self.lastLayoutedBounds = self.bounds
    }
}
