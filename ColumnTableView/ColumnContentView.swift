//
//  ColumnContentView.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 04/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ColumnContentView: UIView {
    private var strongFieldContentReference: UIView?{
        didSet{
            self.fieldContent = self.strongFieldContentReference
        }
    }
    private var strongWidthConstraintReference: NSLayoutConstraint?{
        didSet{
            self.widthConstraint = self.strongWidthConstraintReference
        }
    }
    @IBOutlet weak var fieldContent: UIView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    init(withField field: UIView){
        self.strongFieldContentReference = field
        super.init(frame: CGRect.zero)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    private func setupViews(){
        
    }
    
}
