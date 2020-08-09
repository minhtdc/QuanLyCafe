//
//  SellsViewController.swift
//  QuanLyCafe
//
//  Created by Nguyễn Minh on 8/9/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import UIKit

class SellsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate{
    
    //MARK: Properties
    var food: Food?
    var sell: Sells?
    private var dataSource = [String]()
    private var dataSourceForCol = [String]()
    private var foodList = [Food]()
    private var sellList = [Sells]()
    @IBOutlet weak var txtTongTien: UITextField!
    
    //for Database
    let dao = MyDatabaseAccess()
    static var isCreateTable: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //kích hoạt table view
        SellsTableView.dataSource = self
        SellsTableView.delegate = self

        
        //load data for picker view so luong
        for i in 0...20 {
            let a = i as? NSNumber
            dataSourceForCol.append(a?.stringValue ?? "")
        }
        
        loadFood()
        //load data fo picker view 1
        for food in foodList{
            let name = food.name
            dataSource.append(name)
        }
        
    }
    
    //MARK: Initiatio of data source
    func loadFood(){
        if dao.open(){
            if !SellsViewController.isCreateTable{
                SellsViewController.isCreateTable = dao.createTableFood()
            }
            dao.readFoodList(foods: &foodList)
        }
        
        
    }

    //MARK: Picker View
    @IBOutlet weak var pkvSell: UIPickerView!
    
    //số cột picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //số dòng
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {return dataSource.count}
        if component == 1 {return dataSourceForCol.count}
        return 0
    }
    
    //
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {return dataSource[row]}
        if component == 1 {return dataSourceForCol[row]}
        return ""
    }
    private var soLuong:String = ""
    private var mon:String = ""
    //sự kiện click picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let rowInCol1 = pkvSell.selectedRow(inComponent: 0)
        let rowInCol2 = pkvSell.selectedRow(inComponent: 1)
        //sự kiện
        mon = dataSource[rowInCol1]
        soLuong = dataSourceForCol[rowInCol2]
    }
    
    //Action
    var tongTien: Int = 0
    @IBAction func btnThem(_ sender: Any) {
        sell = Sells(foodName: mon, foodPrince: "10000", soLuong: soLuong)
        sellList.append(sell!)
        SellsTableView.reloadData()
        
        tongTien += Int(soLuong)! * 10000
        txtTongTien.text = "\(tongTien)"
        
    }
    

    //MARK: Table View
    @IBOutlet weak var SellsTableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sellList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellsCell", for: indexPath) as? SellTableViewCell
        let sell = sellList[indexPath.row]
        cell?.foodName.text = sell.foodName
        cell?.soLuong.text = sell.soLuong
        cell?.foodPrince.text = sell.foodPrince
        return cell!
    }
    

}
