//
//  DatabaseLayer.swift
//  FoodManagement2021
//
//  Created by intozoom on 6/10/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import Foundation
import UIKit
import os.log
class DatabaseLayer{
    let DB_NAME="meals.sqlite"
    let DB_PATH:String
    let DB:FMDatabase?
    var isTableCreated = false
    //MARK: table properties
    let TABLE_NAME="meals"
    let ID="_id"
    let MEAL_NAME="name"
    let MEAL_IMAGE="image"
    let MEAL_RATING="rating"
    //constructors
    init() {
        let directories:[String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        DB_PATH = directories[0]+"/"+DB_NAME
        print("URL DATA: \(DB_PATH)")
        DB = FMDatabase(path: DB_PATH)
        if DB != nil {
            os_log("the database is created")
            // create the tables of the database
            isTableCreated = createTables()
        }else{
            os_log("the database is not created")
        }
    }
    //MARK: primitives definition
    //1. create the meal table
    private func createTables()->Bool{
        var ok=false
        if open() {
            let sql="CREATE TABLE "+TABLE_NAME+" ("
            + ID+" INTEGER PRIMARY KEY AUTOINCREMENT, "
            + MEAL_NAME + " TEXT, "
            + MEAL_IMAGE + " TEXT, "
            + MEAL_RATING + " INTEGER);"
            if DB!.executeStatements(sql) {
                ok=true
                os_log("the meal table is created successful")
            } else {
                os_log("the meal table is not created successful")
            }
        }
        close()
        return ok
    }
    //2 . Open the database
    private func open()->Bool{
        var ok=false
        if DB != nil , DB!.open() {
            ok=true
            os_log("the database is opened")
        }else{
            os_log("the database is not opened")
        }
        return ok
    }
    //3. Close the database
    private func close(){
        if DB != nil {
            DB!.close()
        }
    }
    //MARK: DATABASE API
    //1. Write a meal into the database
    func insertMeal(meal:Meal){
        if open(){
            //transform the meal image into string
            var mealPhotoString:String = ""
            if let image = meal.mealImage{
                let imageData: NSData = image.pngData()! as NSData
                mealPhotoString = imageData
                    .base64EncodedString(options: .lineLength64Characters)
            }
            let sql = "INSERT INTO "+TABLE_NAME+"("+MEAL_NAME+","+MEAL_IMAGE+", "+MEAL_RATING+")"+" VALUES (?, ?, ?)"
            if DB!.executeUpdate(sql, withArgumentsIn: [meal.mealName,mealPhotoString,meal.mealRatingValue]){
                os_log("Succeed to Insert into the table")
            }else{
                os_log("Fail to Insert into the table")
            }
        }
        close()
    }
    //2. Read a meals from our database
    func readMeals(meals: inout [Meal]){
        var results: FMResultSet!
        if open() {
            //SQL statement
            let sql = "SELECT * FROM " + TABLE_NAME
            // Execute the query
            do {
                results = try DB!.executeQuery(sql, values: nil)
            }
            catch {
                print("Can not read the meals from the database: \(error.localizedDescription)")
            }
            if results != nil {
                while results.next() {
                    let mealName = results.string(forColumn:MEAL_NAME)!
                    let mealImage = results.string(forColumn:MEAL_IMAGE)!
                    let mealRating = results.int(forColumn:MEAL_RATING)
                    var decodedImage:UIImage? = nil
                    if !mealImage.isEmpty{
                        let dataDecoded : Data = Data(base64Encoded: mealImage,options: .ignoreUnknownCharacters)!
                        decodedImage = UIImage(data:dataDecoded)
                    }
                    //create a meal
                    if let meal = Meal(mealName: mealName, mealImage: decodedImage, mealRatingValue: Int(mealRating)){
                        meals.append(meal)
                    }
                }
            }
        }
        close()
    }
    //3. Update the meals in the database
    func updateMeal(old:Meal, new:Meal){
        if open(){
            let sql = "UPDATE \(TABLE_NAME) SET \(MEAL_NAME) = ?, \(MEAL_IMAGE) = ?, \(MEAL_RATING) = ? WHERE \(MEAL_NAME) = ? AND \(MEAL_RATING) = ?"
            //transform the new image into a string
            //transform the meal image into string
            var mealPhotoString:String = ""
            if let image = new.mealImage{
                let imageData: NSData = image.pngData()! as NSData
                mealPhotoString = imageData
                    .base64EncodedString(options: .lineLength64Characters)
            }
            //
            do {
                try DB!.executeUpdate(sql, values: [new.mealName,mealPhotoString,new.mealRatingValue,old.mealName,old.mealRatingValue])
                os_log("The meal is updated successfull")
            } catch {
                print("Cant not update the meal into the database:\(error.localizedDescription)")
            }
        }
        close()
    }
    //4. Delete the meals in the database
    func deleteMeal(meal:Meal){
        if open() {
            let sql = "DELETE FROM \(TABLE_NAME) WHERE \(MEAL_NAME) = ? AND \(MEAL_RATING) = ?"
            do {
                try DB!.executeUpdate(sql, values: [meal.mealName,meal.mealRatingValue])
                os_log("The meal is deleted successfull")
            }catch{
                print("Can not delete the meal from the database: \(error.localizedDescription)")
            }
        }
    }
}
