//
//  MainViewController.swift
//  QuanLyCafe
//
//  Created by Nguyễn Minh on 8/9/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnThoat(_ sender: Any) {
    }
    
    @IBAction func btnCancel(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
}
