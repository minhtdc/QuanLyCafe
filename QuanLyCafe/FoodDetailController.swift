//
//  ViewController.swift
//  QuanLyCafe
//
//  Created by Nguyễn Minh on 7/23/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import UIKit

class FoodDetailController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    //MARK: Properties
    var food: Food?
    private var dataSource = [String]()
    
    //for Database
    let dao = MyDatabaseAccess()
    static var isCreateTable: Bool = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var edtFoodName: UITextField!
    @IBOutlet weak var edtFoodPrince: UITextField!
    @IBOutlet weak var edtFoodCategory: UITextField!
    
    enum NavigationDirection {
        case addNewFood
        case updateFood
    }
    var navigationDirection: NavigationDirection = .addNewFood
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadCategory()
        
        //uy quyen
        edtFoodName.delegate = self
        edtFoodCategory.delegate = self
        
        //Get the meal from table view controller
        if let theFood = food{
            navigationItem.title = theFood.name
            edtFoodName.text = theFood.name
            foodImage.image = theFood.image
            let prince = theFood.prince as NSNumber
            edtFoodPrince.text = prince.stringValue
            edtFoodCategory.text = theFood.category
            
        }
        
        updateSaveButton()
    }
    
    //MARK: Delegation function of TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        edtFoodName.resignFirstResponder()
        edtFoodCategory.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = edtFoodName.text
        updateSaveButton()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    //MARK: actions
    
    //tap ton picture
    @IBAction func tapOnPictureAction(_ sender: UITapGestureRecognizer) {
        //hide the keyboard
        edtFoodName.resignFirstResponder()
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
        foodImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: For navigation controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pressedButton = sender as? UIBarButtonItem, pressedButton === saveButton else {
            print("This is not the save button!")
            return
        }
        
        //Preparing for the save button pressed
        let foodName = edtFoodName.text ?? ""; //?? nêu lấy được gán, nếu không lấy đc gán default chuỗi sau ??
        let foodPrince = Int(edtFoodPrince.text ?? "")
        let foodCategory = edtFoodCategory.text ?? ""
        food = Food(name: foodName, image: foodImage.image, prince: foodPrince!, category: foodCategory)
        
    }
    
    //MARK: Update save button
    func updateSaveButton(){
        let foodName = edtFoodName.text ?? ""
        saveButton.isEnabled = !foodName.isEmpty
    }
    
    //Cancel new meal
    
    @IBAction func cancelButton(_ sender: Any) {
        switch navigationDirection {
        case .addNewFood:
            dismiss(animated: true, completion: nil)
        case .updateFood:
            if let theNavigationController = navigationController{
                theNavigationController.popViewController(animated: true)
            }
        }
    }
    
    //picker view
    //khai báo đối tượng picker view
    @IBOutlet weak var pkvFoodCategory: UIPickerView!
    
    //load category
    func loadCategory(){
        if dao.open(){
            if !FoodTableViewController.isCreateTable{
                FoodTableViewController.isCreateTable = dao.createTableCategory()
            }
            dataSource = [""];
            dao.realCategory(categories: &dataSource)
        }
        
    }
    
    //them loai
    @IBAction func btnThemLoai(_ sender: Any) {
        let category = edtFoodCategory.text ?? ""
        if dao.open(){
            // hiện hộp thoại xác nhận xoá
            let acExit = UIAlertController(title: "Xác nhận", message: "Bạn có muốn thêm \(category) vào loại không?", preferredStyle: UIAlertController.Style.alert)
            // Xử lý trong trường hợp chọn Đồng ý
            acExit.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { (action: UIAlertAction!) in
                // Viết xử lý tại đây
                self.dao.insertCategory(category: category)
                self.loadCategory()
                self.pkvFoodCategory.reloadAllComponents()
                
            }))
            // Xử lý trong trường hợp chọn Không
            acExit.addAction(UIAlertAction(title: "Không", style: .default, handler: { (action: UIAlertAction!) in
                acExit .dismiss(animated: true, completion: nil)
            }))
            // Hiển thị hộp thoại
            present(acExit, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func btnSuaLoai(_ sender: Any) {
        
    }
    
    //xoa loai
    @IBAction func btnXoaLoai(_ sender: Any) {
        let category = edtFoodCategory.text ?? ""
        if dao.open(){
            
            // hiện hộp thoại xác nhận xoá
            let acExit = UIAlertController(title: "Xác nhận", message: "Bạn có muốn xoá loại không?", preferredStyle: UIAlertController.Style.alert)
            // Xử lý trong trường hợp chọn Đồng ý
            acExit.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { (action: UIAlertAction!) in
                // Viết xử lý tại đây
                self.dao.deleteCategory(category: category)
                self.loadCategory()
                self.pkvFoodCategory.reloadAllComponents()
                
            }))
            // Xử lý trong trường hợp chọn Không
            acExit.addAction(UIAlertAction(title: "Không", style: .default, handler: { (action: UIAlertAction!) in
                acExit .dismiss(animated: true, completion: nil)
            }))
            // Hiển thị hộp thoại
            present(acExit, animated: true, completion: nil)
        }
    }
    
    
    //thiet lap so cot cho picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //thiet lap so dong cho picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
        
    }
    
    //tra ve dong duoc chon trong picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    //thiet lap su kien picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            edtFoodCategory.text = dataSource[row]
            
        }
        
        //sua loai
        
    }
    
}

