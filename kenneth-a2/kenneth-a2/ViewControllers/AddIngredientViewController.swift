//
//  AddIngredientViewController.swift
//  kenneth-a2
//
//  Created by user160075 on 4/29/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class AddIngredientViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, DatabaseListener {

    @IBOutlet weak var ingredientPickerView: UIPickerView!
    @IBOutlet weak var measurementTextField: UITextField!
    
    weak var ingredientDelegate: NewCocktailDelegate?
    var ingredients: [Ingredient] = []
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .ingredients
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        measurementTextField.delegate = self
        
        self.ingredientPickerView.delegate = self
        self.ingredientPickerView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    // MARK: - View Appear/Disappear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: - Database Listener
    func onCocktailListChange(change: DatabaseChange, cocktails: [Cocktail]) {
        // Do nothing not called
    }

    func onGroupChange(change: DatabaseChange, cocktailGroup: [Cocktail]) {
        // Do nothing not called
    }
    
    func onIngredientGroup(change: DatabaseChange, ingredients: [Ingredient]) {
        self.ingredients = ingredients
        ingredientPickerView.reloadAllComponents()
    }
    
    // MARK: - Save Button
    @IBAction func saveIngredient(_ sender: Any) {
        // Get information from ingredient list and measurement text field
        let ingredient = ingredients[ingredientPickerView.selectedRow(inComponent: 0)]
        let measurement = measurementTextField.text!
            
        // Use the delegate to add to the previous view
        if ingredientDelegate?.newIngredientMeasurement(ingredientName: ingredient.name!, ingredientQuantity: measurement) ?? false {
            navigationController?.popViewController(animated: true)
            return
        }
        
        // Display alert if measurement amount not provided
        let errorMsg = "Please ensure all fields are filled:\n- Must provide a measurement amount"
        displayMessage(title: "Not all fields filled", message: errorMsg)
    }
    
    // MARK: UIPickerViewDataSource Protocol Stubs
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ingredients.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ingredients[row].name
    }
    
    // MARK: - Alert
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
