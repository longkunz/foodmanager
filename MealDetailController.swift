//
//  ViewController.swift
//  FoodManagement2021
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit

class MealDetailController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Properties

    @IBOutlet weak var edtMealName: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var meal:Meal?
    
    enum NavigationType {
        case newMeal
        case updateMeal
    }
    var navigationType:NavigationType = .newMeal
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Uy quyen self: chinh la ViewController
        edtMealName.delegate = self
        
        //Lay meal tu table view(khi click 1 cell tu table view se chuyen qua vi tri nay)
        if let theMeal = meal{
            // Dien thong tin meal vao mealDetailController
            edtMealName.text = theMeal.mealName
            navigationItem.title = theMeal.mealName
            
//            anh imgView
            imageView.image = theMeal.mealImage
            
            //Rating value
            ratingControl.ratingValue = theMeal.mealRatingValue
        }
    }
    
    //MARK: TextFiled's Delegate Functions
    //Bam vao phim done se thuc hien ham textFieldShouldReturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Cau lenh duoi dung de an ban phim khi nhan phim done
        textField.resignFirstResponder()
        return true
    }
    
    //Ham duoi day se thuc hien phan code ben trong khi thuc hien xong viec nhap du lieu
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let mealName = textField.text{
//            print("Meal name is:  \(mealName)")
            navigationItem.title = mealName
        }
    }
    
    //MARK: Image processing
    //Ham duoi se tat ban phim khi click vao anh
    @IBAction func imageProcessing(_ sender: UITapGestureRecognizer) {
        //An ban phim
        edtMealName.resignFirstResponder()
        
        //Lay anh tu thu vien
        let imagePicker = UIImagePickerController()
        
        //Cau hinh nguon anh
        imagePicker.sourceType = .photoLibrary
        
        //Uy quyen cho noi dinh nghia ham uy quyen
        imagePicker.delegate = self
        
        //Hien thi anh
        //completion la bien ham
        present(imagePicker,animated: true,completion: nil)
    }
    
    //Ham uy quyen imagePicker
    //info la bien dictionary
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            //dismiss: an man hinh hien tai
            imageView.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if navigationType == .newMeal{
            dismiss(animated: true, completion: nil)
        }
        else{
//             print("updateMeal cancel called")
            if let theNavigationController = navigationController {
                theNavigationController.popViewController(animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let button = sender as? UIBarButtonItem, button === btnSave{
            //Gan gia tri mac dinh cho bien optional = ??
            let mealName = edtMealName.text ?? ""
            let mealImage = imageView.image
            let ratingValue = ratingControl.ratingValue
            
            meal = Meal(mealName: mealName, mealImage: mealImage, mealRatingValue: ratingValue)
        }
    }
}

