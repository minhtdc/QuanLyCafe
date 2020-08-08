//
//  StaffViewController.swift
//  QuanLyCafe
//
//  Created by Nguyễn Minh on 8/8/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import UIKit

class StaffDetailController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    var staff: Staff?
    
    //for Database
    let dao = MyDatabaseAccess()
    static var isCreateTable: Bool = false
    
    @IBOutlet weak var buttonSave: UIBarButtonItem!
    @IBOutlet weak var staffImage: UIImageView!
    @IBOutlet weak var edtMaNV: UITextField!
    @IBOutlet weak var edtTenNV: UITextField!
    @IBOutlet weak var edtNgayLamViec: UITextField!
    @IBOutlet weak var edtSdtNV: UITextField!

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

}
