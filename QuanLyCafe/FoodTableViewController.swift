//
//  FoodTableViewController.swift
//  QuanLyCafe
//
//  Created by Nguyễn Minh on 8/4/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import UIKit

class FoodTableViewController: UITableViewController {
    //MARK: Properties
    private var foodList = [Food]()
    
    //for Database
    let dao = MyDatabaseAccess()
    static var isCreateTable: Bool = false
    
    //Mark the direction of navigation
    enum NavigationDirection {
        case addNewFood
        case updateFood
    }
    var navigationDirection: NavigationDirection = .addNewFood
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load the food list
        loadFood()
        
        //Add the Edit button
        navigationItem.leftBarButtonItem = editButtonItem
        
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
        return foodList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FoodTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FoodTableViewCell else{
            fatalError("Can not read the cell!")
        }
        
        let food = foodList[indexPath.row]
        cell.foodName.text = food.name
        cell.foodImage.image = food.image
        let prince = food.prince as NSNumber
        cell.foodPrince.text = prince.stringValue
        cell.foodCategory.text = food.category
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
            //delete from db
            if dao.open(){
                dao.delete(food: foodList[indexPath.row])
            }
            
            // Delete the row from the data source
            foodList.remove(at: indexPath.row)
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
        guard let destinationController = segue.destination as? FoodDetailController else {
            print("Can not get the destionation controller")
            return
        }
        
        switch identifier {
        case "addFood":
            print("Add a new food")
            navigationDirection = .addNewFood
            destinationController.navigationDirection = .addNewFood
        case "updateFood":
            print("update the food")
            navigationDirection = .updateFood
            //Mark to the destination
            destinationController.navigationDirection = .updateFood
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
            destinationController.food = foodList[indexPath.row]
        default:
            print("You are not name the segue!")
            return
        }
    }
    
    //MARK: Initiatio of data source
    func loadFood(){
        if dao.open(){
            if !FoodTableViewController.isCreateTable{
                FoodTableViewController.isCreateTable = dao.createTable()
            }
            dao.realFoodList(foods: &foodList)
        }
        
        
    }
    
    //MARK: unWind for Segue
    
    @IBAction func unwindFromDetailFoodController(sender: UIStoryboardSegue) {
        //Get the new food from Source Food Detail controller
        switch navigationDirection {
        case .addNewFood:
            if let sourceController = sender.source as? FoodDetailController, let foodNew = sourceController.food {
                //Calculate new possion in the table
                let newIndexPath = IndexPath(row: foodList.count, section: 0)
                //add the new meal into the mealList
                foodList.append(foodNew)
                //insert the new meal into the table view
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
                //insert to db
                if dao.open(){
                    dao.insert(food: foodNew)
                }
                
            }
        case .updateFood:
            if let sourceController = sender.source as? FoodDetailController, let updateFood = sourceController.food {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    //update to database
                    if dao.open(){
                        dao.update(oldFood: foodList[selectedIndexPath.row], newFood: updateFood)
                    }
    
                    //update to the meal list
                    foodList[selectedIndexPath.row] = updateFood
                    //update to table view
                    tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                    
                }
            }
        }
    }
    
}
