//
//  Food.swift
//  QuanLyMonAn
//
//  Created by Nguyễn Minh on 6/28/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import Foundation
import UIKit
class Food {
    var name:String
    var image:UIImage?
    var prince:Int
    var category:String
    
    init?(name:String, image:UIImage?, prince:Int, category:String) {
        guard !name.isEmpty else {
            return nil
        }
        guard !category.isEmpty else {
            return nil
        }
        
        
        self.name = name
        self.image = image
        self.prince = prince
        self.category = category
    }
}
