//
//  DatabaseAccess.swift
//  QuanLyMonAn
//
//  Created by CNTT on 7/27/20.
//  Copyright © 2020 Tran Huynh. All rights reserved.
//

import Foundation
import UIKit
import os.log
class MyDatabaseAccess{
    let dPath : String
    let DB_NAME : String = "Food.sqlite"
    let db : FMDatabase?
    
    // mark : table's properties
    let TABLE_NAME: String = "meals"
    let TABLE_ID: String = "_id"
    let MEAL_NAME: String = "name"
    let MEAL_IMAGE: String = "image"
    let MEAL_RATING: String = "rating"
    
    // mark : constructor
    init(){
        let directories:[String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        dPath = directories[0] + "/" + DEBUG_ASSERT_COMPONENT_NAME_STRING
        db = FMDatabase(path: dPath)
        if db == nil {
            os_log("Can not create yhe database. Plrase review the dPath !")
        }
        else {
            os_log("Database is created successful ! ")
        }
    }
    
    func createTable() -> Bool{
        var ok : Bool = false
        if db != nil {
            let sql = "CREATE TABLE " + TABLE_NAME + "( "
            + TABLE_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
            + MEAL_NAME + " TEXT, "
            + MEAL_IMAGE + " TEXT, "
            + MEAL_RATING + "INTEGER)"
            
            if db!.executeStatements(sql) {
                ok = true
                os_log("Table is created!")
            }
            else{
                os_log("Can not create the table!")
            }
        }
        else{
            os_log("Database is nil")
        }
        return ok
    }
    
    func open() -> Bool{
        var ok: Bool = false
        
        if db != nil{
            if db!.open(){
                ok = true
                os_log("The database is opened !")
            }
            else{
                print("Can not open the database : \(db!.lastErrorMessage())")
            }
        }
        else{
            os_log("Database is nil")
        }
        return ok
    }
    func close(){
        if db != nil {
            db!.close()
        }
    }
    
    func insert(meal: Meal){
        if db != nil{
            // tranform the meal image to string
            let imageData: NSData = meal.image!.pngData()! as NSData
            let mealImageString = imageData.base64EncodedData(options: .lineLength64Characters)
            let sql =  "INSERT INTO " + TABLE_NAME + "(" + MEAL_NAME + ", " + MEAL_IMAGE + ", " + MEAL_RATING + ")" + " VALUES (?, ?, ?)"
            if db!.executeUpdate(sql, withArgumentsIn: [meal.name, mealImageString, meal.rating]){
                os_log("The meal is insert to the database!")
            }
            else{
                os_log("Fail to insert the meal")
                
            }
        }
        else{
            os_log("Database is nil!")
        }
    }
}
