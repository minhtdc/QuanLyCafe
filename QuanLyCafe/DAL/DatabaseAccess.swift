//
//  DatabaseAccess.swift
//  QuanLyCafe
//
//  Created by Nguyễn Minh on 8/5/20.
//  Copyright © 2020 Nguyễn Minh. All rights reserved.
//

import Foundation
import UIKit
import os.log

class MyDatabaseAccess{
    //MARK: Properties
    let dPath: String
    let DB_NAME: String = "Menu.sqlite"
    let db: FMDatabase?
    
    //MARK: Table's propertie
    let TABLE_NAME: String = "foods"
    let TABLE_ID: String = "_id"
    let MEAL_NAME: String = "name"
    let MEAL_IMAGE: String = "image"
    let MEAL_PRINCE: String = "prince"
    let MEAL_CATEGORY: String = "category"
    
    //MARK: Contructor
    init() {
        let directories:[String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        dPath = directories[0] + "/" + DB_NAME
        db = FMDatabase(path: dPath)
        if db == nil{
            os_log("Can not create the database. Please review the Path!")
        }
        else{os_log("Database is created successful!")}
    }
    
    //MARK: Primities Action
    func createTable() -> Bool{
        var ok: Bool = false
        
        if db != nil{
            let sql = "CREATE TABLE " + TABLE_NAME + "( "
                + TABLE_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + MEAL_NAME + " TEXT, "
                + MEAL_IMAGE + " TEXT, "
                + MEAL_PRINCE + " INTEGER, "
                + MEAL_CATEGORY + " TEXT, "
                + "MaLoai" + " REFERENCES Category(MaLoai))"
            
            if db!.executeStatements(sql){
                ok = true
                os_log("Table is created!")
            }
            else{
                os_log("Can not create the table")
            }
        }
        else{
            os_log("Database is null")
        }
        return ok
    }
    
    //Open data
    func open() -> Bool{
        var ok: Bool = false
        
        if db != nil {
            if db!.open() {
                ok = true
                os_log("The database is opened!")
            }
            else{
                print("Can not open the Database: \(db!.lastErrorMessage())")
            }
        }
        else{
            os_log("Database is null!")
        }
        return ok
    }
    
    //Close database
    func close(){
        if db != nil{
            db!.close()
        }
    }
    
    
    //MARK: APIs
    func insert(food: Food){
        if db != nil{
            //Transform the meal image to string
            let imageData: NSData = food.image!.pngData()! as NSData
            let mealImageString = imageData.base64EncodedData(options: .lineLength64Characters)
            
            let sql = "INSERT INTO " + TABLE_NAME + "(" + MEAL_NAME + ", " + MEAL_IMAGE + ", " + MEAL_PRINCE + "," + MEAL_CATEGORY + ")" + " VALUES (?, ?, ?, ?)"
            
            if db!.executeUpdate(sql, withArgumentsIn: [food.name, mealImageString, food.prince, food.category]){
                os_log("The food is insert to the database!")
                
            }else{
                os_log("Fail to insert the meal!")
            }
            
        }
        else{
            os_log("Database is nil!")
        }
    }
    func delete(food: Food){
        if db != nil {
            let sql = "DELETE FROM \(TABLE_NAME) WHERE \(MEAL_NAME) = ? AND \(MEAL_CATEGORY) = ?"
            do{
                try db!.executeUpdate(sql, values: [food.name, food.category])
                os_log("The food is deleted!")
                
            }
            catch {
                os_log("Fail to delete the food")
            }
        }
        else{
            os_log("Database is nil")
        }
    }
    
    //real meal list
    func realFoodList(foods:inout [Food]){
        if db != nil {
            var result: FMResultSet?
            let sql = "SELECT * FROM \(TABLE_NAME)"
            //Query
            do {
                result = try db!.executeQuery(sql, values: nil)
            }
            catch{
                print("Fail to real data: \(error.localizedDescription)")
            }
            
            //real data from the results
            if result != nil{
                while(result?.next())!{
                    let foodName = result!.string(forColumn: MEAL_NAME) ?? ""
                    let stringImage = result!.string(forColumn: MEAL_IMAGE)
                    let foodPrince = result!.int(forColumn: MEAL_PRINCE)
                    let foodCategory = result!.string(forColumn: MEAL_CATEGORY) ?? ""
                    //transform string image to UIImage
                    let dataImage: Data = Data(base64Encoded: stringImage!, options: .ignoreUnknownCharacters)!
                    let mealImage = UIImage(data: dataImage)
                    //create a meal to contain the values
                    let food = Food(name: foodName, image: mealImage!, prince: Int(foodPrince), category: foodCategory)
                    foods.append(food!)
                    
                }
            }
            
        }
        else{
            os_log("Database is nil")
        }
    }
    
    
    //update
    func update(oldFood: Food, newFood: Food){
        if db != nil {
            let sql = "UPDATE \(TABLE_NAME) SET \(MEAL_NAME) = ?, \(MEAL_IMAGE) = ?, \(MEAL_PRINCE) = ?, \(MEAL_CATEGORY) = ? WHERE \(MEAL_NAME) = ? AND \(MEAL_CATEGORY) = ?"
            //transform image of new meal to string
            let newImageData: NSData = newFood.image!.pngData()! as NSData
            let newStringImage = newImageData.base64EncodedData(options: .lineLength64Characters)
            //try to query the database
            do {
                try db!.executeUpdate(sql, values: [newFood.name, newStringImage, newFood.prince, newFood.category, oldFood.name, oldFood.category])
                os_log("Successful to update the food")
            }
            catch{
                print("Fail to update data: \(error.localizedDescription)")
            }
            
        }
        else{
            os_log("Database is nil")
        }
    }
    
    //CATEGORY
    
    //create tablecategory
    func createTableCategory() -> Bool{
        var ok: Bool = false
        
        if db != nil{
            let sql = "CREATE TABLE " + "Category" + "( "
                + "MaLoai" + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + "foodCategory" + " TEXT)"
            
            if db!.executeStatements(sql){
                ok = true
                os_log("Table Category is created!")
            }
            else{
                os_log("Can not create table category")
            }
        }
        else{
            os_log("Database is null")
        }
        return ok
    }
    
    //real category list
    func realCategory(categories:inout [String]){
        if db != nil {
            var result: FMResultSet?
            let sql = "SELECT * FROM Category"
            //Query
            do {
                result = try db!.executeQuery(sql, values: nil)
            }
            catch{
                print("Fail to real category: \(error.localizedDescription)")
            }
            
            //real data from the results
            if result != nil{
                while(result?.next())!{
                    let category = result!.string(forColumn: "foodCategory") ?? ""
                    categories.append(category)
                    
                }
            }
            
        }
        else{
            os_log("Database is nil")
        }
    }
    
    //add category
    func insertCategory(category: String){
        if db != nil{
            
            let sql = "INSERT INTO Category(foodCategory) VALUES (?)"
            
            if db!.executeUpdate(sql, withArgumentsIn: [category]){
                os_log("The category is insert to the database!")
                
            }else{
                os_log("Fail to insert the category!")
            }
            
        }
        else{
            os_log("Database is nil!")
        }
    }
    
    //update category
    func update(oldCategory: String, newCategory: String){
        if db != nil {
            let sql = "UPDATE Category SET foodCategory = ?,  WHERE foodCategory = ?"
            
            //try to query the database
            do {
                try db!.executeUpdate(sql, values: [oldCategory, newCategory])
                os_log("Successful to update the category")
            }
            catch{
                print("Fail to update category: \(error.localizedDescription)")
            }
            
        }
        else{
            os_log("Database is nil")
        }
    }
    
    //delete category
    func deleteCategory(category: String){
        if db != nil {
            let sql = "DELETE FROM Category WHERE foodCategory = ?"
            do{
                try db!.executeUpdate(sql, values: [category])
                os_log("The category is deleted!")
                
            }
            catch {
                os_log("Fail to delete the category")
            }
        }
        else{
            os_log("Database is nil")
        }
    }
    
    
}

