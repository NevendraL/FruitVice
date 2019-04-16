//
//  ViewController.swift
//  FruitVice
//
//  Created by Nevendra lall on 4/16/19.
//  Copyright © 2019 Nevendra lall. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import SVProgressHUD



class ViewController: UIViewController {
    
    let fruitDataModel: FruitDataModel = FruitDataModel()
    let url: String = "http://fruityvice.com/api/fruit/"
    var imageUrl: String = "http://fruityvice.com/images/"
    
    
    @IBOutlet weak var fruitImage: UIImageView!
    @IBOutlet weak var fruitNameLabel: UILabel!
    @IBOutlet weak var fruitCaloriesLabel: UILabel!
    @IBOutlet weak var fruitProteinLabel: UILabel!
    @IBOutlet weak var fruitCarbsLabel: UILabel!
    @IBOutlet weak var fruitFatLabel: UILabel!
    @IBOutlet weak var fruitInputTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func searchFruitButton(_ sender: Any) {
        
        if (fruitInputTextField.text?.isEmpty)!{
            SVProgressHUD.showInfo(withStatus: "Enter a fruit...")
            
        }else{
            //updates url based on search criteria of the inputted fruit.
            let finalUrl: String = url + (fruitInputTextField.text?.lowercased())!
            let finalImageUrl = imageUrl + (fruitInputTextField.text?.lowercased())! + ".png"
            
            downloadJson(url: finalUrl)
            downloadImage(url: finalImageUrl)
            fruitInputTextField.text = ""
            
        }
        
    }
    
    
    func downloadJson(url: String){
        SVProgressHUD.show(withStatus: "Loading...")
        
        Alamofire.request(url).responseJSON { response in
            if response.result.isSuccess{
                let json = JSON(response.result.value!)
                //call parseJSON method if response was successful
                self.parseJson(jsonData: json)
                self.updateUi()
                
                
            }else{
                //Handles error if the user have no wifi connection...
                SVProgressHUD.showError(withStatus: "No Wifi connection, try again later...")
                
            }
        }
        
    }
    
    func parseJson(jsonData: JSON){
        
        let calories = jsonData["nutritions"]["calories"]
        let protein = jsonData["nutritions"]["protein"]
        let carbs = jsonData["nutritions"]["carbohydrates"]
        let fat = jsonData["nutritions"]["fat"]
        
        //sends the parsed data to the fruitDataModel
        fruitDataModel.fruitCalories = calories.doubleValue
        fruitDataModel.fruitProtein = protein.doubleValue
        fruitDataModel.fruitCarbs = carbs.doubleValue
        fruitDataModel.fruitFat = fat.doubleValue
        SVProgressHUD.dismiss()
        
    }
    
    
    func downloadImage(url: String){
        Alamofire.request(url).responseImage { response in
            debugPrint(response)
            
            if response.result.isSuccess {
                let image = response.result.value
                self.fruitImage.image = image!
            }else{
                //handles error if program fails to download an image.
                //if no image was found then that means no fruit data was loaded as well.
                self.fruitImage.image = UIImage(named: "error.png")
                SVProgressHUD.showError(withStatus: "Sorry, no fruit data found, try again..")
            }
        }
        
    }
    
    func updateUi(){
        //updates UI with Data from the FruitDataModel
        
        fruitCaloriesLabel.text = "Calories: " + String(fruitDataModel.fruitCalories)
        fruitProteinLabel.text = "Protein: " + String(fruitDataModel.fruitProtein)
        fruitCarbsLabel.text = "Carbs: " + String(fruitDataModel.fruitCarbs)
        fruitFatLabel.text = "Fat: " + String(fruitDataModel.fruitFat)
    }
    
    
    
    
}

