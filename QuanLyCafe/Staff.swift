//
//  Staff.swift
//  QuanLyCafe
//
//  Created by Nguyễn Minh on 8/8/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import Foundation
import UIKit
class Staff {
    var maNV: String
    var imageNV: UIImage?
    var tenNV: String
    var SDT:String
    var diaChiNV: String
    
    init?(maNV:String, tenNV:String, imageNV:UIImage?, SDT: String, diaChiNV:String) {
        guard !maNV.isEmpty else {
            return nil
        }
        guard !tenNV.isEmpty else {
            return nil
        }
        guard !SDT.isEmpty else {
            return nil
        }
        guard !diaChiNV.isEmpty else {
            return nil
        }
        
        self.maNV = maNV
        self.tenNV = tenNV
        self.imageNV = imageNV
        self.SDT = SDT
        self.diaChiNV = diaChiNV
    }
}
