//
//  FoodTableViewCell.swift
//  QuanLyCafe
//
//  Created by Nguyễn Minh on 8/4/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    //MARK: Cell properties
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UITextField!
    @IBOutlet weak var foodPrince: UITextField!
    @IBOutlet weak var foodCategory: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
