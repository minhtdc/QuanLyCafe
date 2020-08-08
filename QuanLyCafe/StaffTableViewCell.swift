//
//  StaffTableViewCell.swift
//  QuanLyCafe
//
//  Created by Nguyễn Minh on 8/8/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import UIKit

class StaffTableViewCell: UITableViewCell {
    
    
    
    //Mark: Cell properties

    @IBOutlet weak var staffImage: UIImageView!
    @IBOutlet weak var tenNV: UITextField!
    @IBOutlet weak var maNV: UITextField!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
