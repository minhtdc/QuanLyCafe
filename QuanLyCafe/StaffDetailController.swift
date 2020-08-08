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
    

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var staffImage: UIImageView!
    @IBOutlet weak var edtMaNV: UITextField!
    @IBOutlet weak var edtTenNV: UITextField!
    @IBOutlet weak var edtDiaChiNV: UITextField!
    @IBOutlet weak var edtSdtNV: UITextField!
    
    enum NavigationDirection {
        case addNewStaff
        case updateStaff
    }
    var navigationDirection: NavigationDirection = .addNewStaff
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //uy quyen
        edtMaNV.delegate = self
        edtTenNV.delegate = self
        edtSdtNV.delegate = self
        edtDiaChiNV.delegate = self
        
        //Get the meal from table view controller
        if let theStaff = staff{
            navigationItem.title = theStaff.tenNV
            edtTenNV.text = theStaff.tenNV
            staffImage.image = theStaff.imageNV
            edtSdtNV.text = theStaff.SDT
            edtDiaChiNV.text = theStaff.diaChiNV
            
        }
        
        updateSaveButton()
    }
    
    //MARK: Delegation function of TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        edtTenNV.resignFirstResponder()
        edtMaNV.resignFirstResponder()
        edtDiaChiNV.resignFirstResponder()
        edtSdtNV.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = edtMaNV.text
        updateSaveButton()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    //MARK: actions
    //tap ton picture
    @IBAction func staffImage(_ sender: UITapGestureRecognizer) {
        //hide the keyboard
        edtMaNV.resignFirstResponder()
        //create object of ImagePickerController
        let imagePicker = UIImagePickerController()
        //config the imageController
        imagePicker.sourceType = .photoLibrary
        //delegation of imagePicker
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Delegate function of Image Picker Controller
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            fatalError("Can not get the image")
        }
        
        // Load image to the imageView
        staffImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: For navigation controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pressedButton = sender as? UIBarButtonItem, pressedButton === saveButton else {
            print("This is not the save button!")
            return
        }
        
        //Preparing for the save button pressed
        let maNV = edtMaNV.text ?? "" //?? nêu lấy được gán, nếu không lấy đc gán default chuỗi sau ??
        let tenNV = edtTenNV.text ?? ""
        let sdtNV = edtSdtNV.text ?? ""
        let diaChiNV = edtDiaChiNV.text ?? ""
        staff = Staff(maNV: maNV, tenNV: tenNV, imageNV: staffImage.image, SDT: sdtNV, diaChiNV: diaChiNV)
        
    }
    //MARK: Update save button
    func updateSaveButton(){
        let staffMaNV = edtMaNV.text ?? ""
        saveButton.isEnabled = !staffMaNV.isEmpty
    }
    
    
    @IBAction func btnCanCel(_ sender: Any) {
        switch navigationDirection {
        case .addNewStaff:
            dismiss(animated: true, completion: nil)
        case .updateStaff:
            if let theNavigationController = navigationController{
                theNavigationController.popViewController(animated: true)
            }
        }
        
    }
    
}
