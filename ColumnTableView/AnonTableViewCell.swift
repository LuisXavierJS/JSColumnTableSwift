//
//  AnonTableViewCell.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 06/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class AnonTableViewCell: UITableViewCell {

    @IBOutlet weak var titulo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
