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
    let DB_NAME: String = "QLCafe.sqlite"
    let db: FMDatabase?
    
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
    
    
    //MARK: TABLE MENU
    //Table Menu properties
    let TABLE_NAME: String = "menu"
    let TABLE_ID: String = "_id"
    let MEAL_NAME: String = "name"
    let MEAL_IMAGE: String = "image"
    let MEAL_PRINCE: String = "prince"
    let MEAL_CATEGORY: String = "category"
    //Creata table Menu
    func createTableFood() -> Bool{
        var ok: Bool = false
        
        if db != nil{
            let sql = "CREATE TABLE " + TABLE_NAME + "( "
                + TABLE_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + MEAL_NAME + " TEXT, "
                + MEAL_IMAGE + " TEXT, "
                + MEAL_PRINCE + " INTEGER, "
                + MEAL_CATEGORY + " TEXT)"
            
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
    
    //read meal list
    func readFoodList(foods:inout [Food]){
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
    
    //them mon
    func insertFood(food: Food){
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
    func deleteFood(food: Food){
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
    
    //update món
    func updateFood(oldFood: Food, newFood: Food){
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
    
    //MARK: TABLE CATEGORY
    
    //create tablecategory
    func createTableCategory() -> Bool{
        var ok: Bool = false
        
        if db != nil{
            let sql = "CREATE TABLE Category(foodCategory TEXT)"
            
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
    
    //read category list
    func readCategory(categories:inout [String]){
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
    
    // MARK: TABLE NHAN VIEN
    //Table Nhan vien properties
    let TABLE_NHANVIEN: String = "NhanVien"
    let MA_NV: String = "maNV"
    let TEN_NV: String = "name"
    let IMAGE_NV: String = "imageNV"
    let DIACHI_NV: String = "diaChiNV"
    let SDT_NV: String = "SdtNV"
    
    //Create table Nhan vien
    func createTableNhanVien() -> Bool{
        var ok: Bool = false
        
        if db != nil{
            let sql = "CREATE TABLE " + TABLE_NHANVIEN + "( "
                + MA_NV + " TEXT PRIMARY KEY, "
                + TEN_NV + " TEXT, "
                + IMAGE_NV + " TEXT, "
                + SDT_NV + " TEXT, "
                + DIACHI_NV + " TEXT)"
            
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
    
    //Read table nhan vien
    func readStaffList(staffs:inout [Staff]){
        if db != nil {
            var result: FMResultSet?
            let sql = "SELECT * FROM \(TABLE_NHANVIEN)"
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
                    let maNV = result!.string(forColumn: MA_NV) ?? ""
                    let imageNV = result!.string(forColumn: IMAGE_NV)
                    let tenNV = result!.string(forColumn: TEN_NV) ?? ""
                    let diaChiNV = result!.string(forColumn: DIACHI_NV) ?? ""
                    let SdtNV = result!.string(forColumn: SDT_NV) ?? ""
                    //transform string image to UIImage
                    let dataImage: Data = Data(base64Encoded: imageNV!, options: .ignoreUnknownCharacters)!
                    let staffImage = UIImage(data: dataImage)
                    //create a meal to contain the values
                    let staff = Staff(maNV: maNV, tenNV: tenNV, imageNV: staffImage!, SDT: SdtNV, diaChiNV: diaChiNV)
                    staffs.append(staff!)
                    
                }
            }
            
        }
        else{
            os_log("Database is nil")
        }
    }
    //them nhan vien
    func insertNhanVien(staff: Staff){
        if db != nil{
            //Transform the meal image to string
            let imageData: NSData = staff.imageNV!.pngData()! as NSData
            let staffImageString = imageData.base64EncodedData(options: .lineLength64Characters)
            
            let sql = "INSERT INTO \(TABLE_NHANVIEN)(\(MA_NV), \(TEN_NV), \(IMAGE_NV), \(SDT_NV), \(DIACHI_NV)) VALUES (?, ?, ?, ?, ?)"
            
            if db!.executeUpdate(sql, withArgumentsIn: [staff.maNV, staff.tenNV, staffImageString, staff.SDT, staff.diaChiNV]){
                os_log("The staff is insert to the database!")
                
            }else{
                os_log("Fail to insert the staff!")
            }
            
        }
        else{
            os_log("Database is nil!")
        }
    }
    
    //Sua nhan vien
    func updateNhanVien(oldStaff: Staff, newStaff: Staff){
        if db != nil {
            let sql = "UPDATE \(TABLE_NHANVIEN) SET \(MA_NV) = ?, \(TEN_NV) = ?, \(IMAGE_NV) = ?, \(SDT_NV) = ? WHERE \(DIACHI_NV) = ? AND \(MA_NV) = ?"
            //transform image of new meal to string
            let newImageData: NSData = newStaff.imageNV!.pngData()! as NSData
            let newStringImage = newImageData.base64EncodedData(options: .lineLength64Characters)
            //try to query the database
            do {
                try db!.executeUpdate(sql, values: [newStaff.maNV, newStaff.tenNV, newStringImage, newStaff.SDT, newStaff.diaChiNV, oldStaff.maNV])
                os_log("Successful to update the staff")
            }
            catch{
                print("Fail to update data: \(error.localizedDescription)")
            }
            
        }
        else{
            os_log("Database is nil")
        }
    }
    
    //Xoa nhan vien
    func deleteNhanVien(staff: Staff){
        if db != nil {
            let sql = "DELETE FROM \(TABLE_NHANVIEN) WHERE \(MA_NV) = ? AND \(TEN_NV) = ?"
            do{
                try db!.executeUpdate(sql, values: [staff.maNV, staff.tenNV])
                os_log("The staff is deleted!")
                
            }
            catch {
                os_log("Fail to delete the staff")
            }
        }
        else{
            os_log("Database is nil")
        }
    }
    
    //MARK: TABLE
    
    //create table
    func createTableBan() -> Bool{
        var ok: Bool = false
        
        if db != nil{
            let sql = "CREATE TABLE Ban(soBan TEXT)"
            
            if db!.executeStatements(sql){
                ok = true
                os_log("Table is created!")
            }
            else{
                os_log("Can not create table")
            }
        }
        else{
            os_log("Database is null")
        }
        return ok
    }
    
    //read table list
    func readBan(Table:inout [String]){
        if db != nil {
            var result: FMResultSet?
            let sql = "SELECT * FROM Ban"
            //Query
            do {
                result = try db!.executeQuery(sql, values: nil)
            }
            catch{
                print("Fail to real table: \(error.localizedDescription)")
            }
            
            //read data from the results
            if result != nil{
                while(result?.next())!{
                    let soBan = result!.string(forColumn: "soBan") ?? ""
                    Table.append(soBan)
                    
                }
            }
            
        }
        else{
            os_log("Database is nil")
        }
    }
    
    //add table
    func addTable(Table: String){
        if db != nil{
            
            let sql = "INSERT INTO Ban(soBan) VALUES (?)"
            
            if db!.executeUpdate(sql, withArgumentsIn: [Table]){
                os_log("The table is insert to the database!")
                
            }else{
                os_log("Fail to insert the table!")
            }
            
        }
        else{
            os_log("Database is nil!")
        }
    }
    
    //delete table
    func deleteTable(Table: String){
        if db != nil {
            let sql = "DELETE FROM Ban WHERE soBan = ?"
            do{
                try db!.executeUpdate(sql, values: [Table])
                os_log("The table is deleted!")
                
            }
            catch {
                os_log("Fail to delete the table")
            }
        }
        else{
            os_log("Database is nil")
        }
    }
    
    
}

