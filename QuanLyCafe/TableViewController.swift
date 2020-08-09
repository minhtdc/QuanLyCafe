//
//  TableViewController.swift
//  QuanLyCafe
//
//  Created by Nguyễn Minh on 8/9/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    //MARK: Properties
    private var tableList = [String]()
    
    
    //for Database
    let dao = MyDatabaseAccess()
    static var isCreateTable: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTable()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell else{
            fatalError("Can not read the cell!")
        }
        
        // Configure the cell...
        cell.lblTable.text = tableList[indexPath.row]
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //load ban
    //load category
    func loadTable(){
        if dao.open(){
            if !TableViewController.isCreateTable{
                TableViewController.isCreateTable = dao.createTableBan()
            }
            dao.readBan(Table: &tableList)
        }
        
    }
    
    
    //them mot ban
    @IBAction func btnThemBan(_ sender: Any) {
        for i in tableList.count + 1..<tableList.count + 2{
            tableList.append("Ban so \(i)")
            tableView.reloadData()
            if dao.open(){
            dao.addTable(Table: "Ban so \(i)")
            }
        }
    }
    @IBAction func btnXoaBan(_ sender: Any) {
        // hiện hộp thoại xác nhận xoá
        let acExit = UIAlertController(title: "Xác nhận", message: "Bạn có muốn xoá bớt bàn không?", preferredStyle: UIAlertController.Style.alert)
        // Xử lý trong trường hợp chọn Đồng ý
        acExit.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { (action: UIAlertAction!) in
            // Viết xử lý tại đây
            if self.dao.open(){
                self.dao.deleteTable(Table: "Ban so \(self.tableList.count)")
            }
            self.tableList.removeAll()
            self.loadTable()
            self.tableView.reloadData()
            
            
        }))
        // Xử lý trong trường hợp chọn Không
        acExit.addAction(UIAlertAction(title: "Không", style: .default, handler: { (action: UIAlertAction!) in
            acExit .dismiss(animated: true, completion: nil)
        }))
        // Hiển thị hộp thoại
        present(acExit, animated: true, completion: nil)
    }
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
