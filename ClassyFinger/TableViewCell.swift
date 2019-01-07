//
//  TableViewCell.swift
//  ClassyFinger
//
//  Created by Tomas Galvan-Huerta on 1/5/19.
//  Copyright © 2019 Somat. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
