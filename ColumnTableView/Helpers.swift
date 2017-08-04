//
//  Helpers.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 04/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    class func activateIfNotActive(_ constraints: [NSLayoutConstraint]){
        let notActive = constraints.filter({!$0.isActive})
        self.activate(notActive)
    }
}
