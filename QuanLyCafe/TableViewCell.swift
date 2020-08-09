//
//  TableViewCell.swift
//  QuanLyCafe
//
//  Created by Nguyễn Minh on 8/9/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var lblTable: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
