//
//  MealTableViewController.swift
//  FoodManagement2021
//
//  Created by CNTT on 5/8/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
    // MARK: Properties
    var mealList = [Meal]()
    enum NavigationType {
        case newMeal
        case updateMeal
    }
    
    var navigationType:NavigationType = .newMeal
    let dao = DatabaseLayer()
    override func viewDidLoad() {
        super.viewDidLoad()

//        if let meal = Meal(mealName: "Mon Hue", mealImage: UIImage(named: "defaultImage") , mealRatingValue: 4){
//            mealList += [meal]
//        }
        //load the meals from the database
        dao.readMeals(meals: &mealList)
        
        //Them Edit menu button
        navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mealList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "MealTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? MealTableViewCell{
            // Lay data source cho table view
            let meal = mealList[indexPath.row]
            //Dien thong tin mon an vao cell
            cell.mealName.text = meal.mealName
            cell.mealImage.image = meal.mealImage
            cell.ratingControl.ratingValue = meal.mealRatingValue
            
            return cell
        }
        else{
            fatalError("Can not get the cell!")
        }
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
            //delete the meal from the database
            dao.deleteMeal(meal:mealList[indexPath.row])
            // Delete the row from the data source
            mealList.remove(at: indexPath.row)
            //Xoa dong tu bang tableview o vi tri indexPath
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
    @IBAction func unWindFromMealDetailToMealTableView(sender: UIStoryboardSegue){
//        print("Called from MealDetail")
        if navigationType == .newMeal {
            //Add a meal
            if let sourceController = sender.source as? MealDetailController{
                if let newMeal = sourceController.meal{
                    //Create new indexPath for the new meal
                    let indexPath = IndexPath(row: mealList.count, section: 0)
                    //Insert new meal to the mealList
                    mealList.append(newMeal)
                    //Them mon an moi vao table view
                    tableView.insertRows(at: [indexPath], with: .none)
                    //write the new meal into the database
                    dao.insertMeal(meal: newMeal)
                }
            }
        }
        else{
            //Update a meal
            if let sourceController = sender.source as? MealDetailController{
                if let newMeal = sourceController.meal{
                   
                    if let selectedIndexPath = tableView.indexPathForSelectedRow{
                        //update the new meal to the database
                        dao.updateMeal(old:mealList[selectedIndexPath.row], new: newMeal)
                        //Cap nhap mealList tai vi tri selectedIndexPath
                        mealList[selectedIndexPath.row] = newMeal;
                        
                        //cap nhap row voi du lieu new meal tai vi tri selected index Path
                        tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    }
                }
            }
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Kiem tra cach di toi meal detail controller
        if let segueName = segue.identifier{
            
            if segueName == "addMeal"{
//                print("Add new meal")
                navigationType = .newMeal
                
                if let destinationController = segue.destination as? MealDetailController{
                    
                    destinationController.navigationType = .newMeal
                }
            }
            else{
//                print("Update a meal")
                navigationType = .updateMeal
                if let selectedCell = sender as? MealTableViewCell{
                    //            print("Meal Table View Cell is pressed")
                    let mealName = selectedCell.mealName.text ?? ""
                    let mealImage = selectedCell.mealImage.image
                    let ratingValue = selectedCell.ratingControl.ratingValue
                    
                    let meal = Meal(mealName: mealName, mealImage: mealImage, mealRatingValue: ratingValue)
                    
                    if let destinationController = segue.destination as? MealDetailController{
                        destinationController.meal = meal
                        
                        destinationController.navigationType = .updateMeal
                    }
                }
            }
        }
        else{
            print("You must name for the segue")
        }
    }
}
