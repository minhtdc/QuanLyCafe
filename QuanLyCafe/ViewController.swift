//
//  ViewController.swift
//  QuanLyCafe
//
//  Created by Nguyễn Minh on 7/23/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   
    @IBOutlet weak var topContraintHeight: NSLayoutConstraint!

    @IBAction func showSignIn(_ sender: Any) {
//        topContraintHeight.constant = 0;
//        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
//            self.view.layoutIfNeeded()
//            }, completion: nil)
        print("clicked")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //giao dien cua minh
    }


}
