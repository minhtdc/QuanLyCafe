//
//  SellTableViewCell.swift
//  QuanLyCafe
//
//  Created by Nguyễn Minh on 8/10/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import UIKit

class SellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodName: UITextField!
    @IBOutlet weak var foodPrince: UITextField!
    @IBOutlet weak var soLuong: UITextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
