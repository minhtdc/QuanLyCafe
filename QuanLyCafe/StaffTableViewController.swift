//
//  StaffTableViewController.swift
//  QuanLyCafe
//
//  Created by Nguyễn Minh on 8/8/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import UIKit

class StaffTableViewController: UITableViewController {
    //MARK: Properties
    private var staffList = [Staff]()
    
    //for Database
    let dao = MyDatabaseAccess()
    static var isCreateTable: Bool = false
    
    //Mark the direction of navigation
    enum NavigationDirection {
        case addNewStaff
        case updateStaff
    }
    var navigationDirection: NavigationDirection = .addNewStaff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load the food list
        loadStaff()
        
        //Add the Edit button
        //navigationItem.leftBarButtonItem = editButtonItem
        
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
        return staffList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "StaffTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StaffTableViewCell else{
            fatalError("Can not read the cell!")
        }
        
        let staff = staffList[indexPath.row]
        cell.maNV.text = staff.maNV
        cell.tenNV.text = staff.tenNV
        cell.staffImage.image = staff.imageNV
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        //Get the desnitination of seque
        guard let destinationController = segue.destination as? StaffDetailController else {
            print("Can not get the destionation controller")
            return
        }
        
        switch identifier {
        case "addStaff":
            print("Add a new staff")
            navigationDirection = .addNewStaff
            destinationController.navigationDirection = .addNewStaff
        case "updateStaff":
            print("update the staff")
            navigationDirection = .updateStaff
            //Mark to the destination
            destinationController.navigationDirection = .updateStaff
            //get the seleted cell
            guard let selectedCell = sender as? FoodTableViewCell else{
                print("Cannot get the selected cell")
                return
            }
            //get the possition of selected Cell in the mealList
            guard let indexPath = tableView.indexPath(for: selectedCell) else{
                print("Can not get the possition of the selected cell!")
                return
            }
            
            //Get the food of selected cell to give the distination controller
            destinationController.staff = staffList[indexPath.row]
        default:
            print("You are not name the segue!")
            return
        }
    }
    //MARK: Initiatio of data source
    func loadStaff(){
        if dao.open(){
            if !FoodTableViewController.isCreateTable{
                FoodTableViewController.isCreateTable = dao.createTable()
            }
            dao.readStaffList(staffs: &staffList)
        }
        
    }
    //MARK: unWind for Segue
    @IBAction func unwindFromDetailStaffController(sender: UIStoryboardSegue) {
        //Get the new food from Source Food Detail controller
        switch navigationDirection {
        case .addNewStaff:
            if let sourceController = sender.source as? StaffDetailController, let staffNew = sourceController.staff {
                //Calculate new possion in the table
                let newIndexPath = IndexPath(row: staffList.count, section: 0)
                //add the new meal into the mealList
                staffList.append(staffNew)
                //insert the new meal into the table view
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
                //insert to db
                if dao.open(){
                    dao.insertNhanVien(staff: staffNew)
                }
                
            }
        case .updateStaff:
            if let sourceController = sender.source as? StaffDetailController, let updateStaff = sourceController.staff {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    //update to database
                    if dao.open(){
                        dao.updateNhanVien(oldStaff: staffList[selectedIndexPath.row], newStaff: updateStaff)
                    }
                    
                    //update to the meal list
                    staffList[selectedIndexPath.row] = updateStaff
                    //update to table view
                    tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                    
                }
            }
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
