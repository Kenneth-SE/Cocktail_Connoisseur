//
//  CreateCocktailTableViewController.swift
//  kenneth-a2
//
//  Created by user160075 on 4/29/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class CreateCocktailTableViewController: UITableViewController, NewCocktailDelegate {
    
    // Constants
    let SECTION_NAME = 0
    let SECTION_INSTRUCTIONS = 1
    let SECTION_INGREDIENTS_LIST = 2
    let SECTION_INGREDIENTS = 3
    
    let CELL_NAME = "cocktailNameCell"
    let CELL_INSTRUCTIONS = "instructionsCell"
    let CELL_INGREDIENTS_LIST = "ingredientsListCell"
    let CELL_INGREDIENTS = "ingredientsCell"
    
    let SECTION_NAME_HEADING = "Cocktail name:"
    let SECTION_INSTRUCTIONS_HEADING = "Instructions:"
    let SECTION_INGREDIENTS_LIST_HEADING = "Ingredients:"
    
    weak var databaseController: DatabaseProtocol?
    
    var newDraftCocktail: Cocktail = Cocktail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    // MARK: - View Appear/Disappear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Only discard if user presses back button to the "My Drinks" page
        if isMovingFromParent {
            databaseController?.discardDraft()
        }
    }
    
    // MARK: - Save button
    @IBAction func createCocktail(_ sender: Any) {
        // Check all entries are filled
        if newDraftCocktail.name == nil || newDraftCocktail.instructions == nil || newDraftCocktail.ingredients?.count == 0 {
            
            var errorMsg = "Please ensure all fields are filled:\n"
            
            if newDraftCocktail.name == nil {
                errorMsg += "- Must provide a cocktail name\n"
            }
            
            if newDraftCocktail.instructions == nil {
                errorMsg += "- Must provide instructions\n"
            }
            
            if newDraftCocktail.ingredients?.count == 0 {
                errorMsg += "- Must provide at least one ingredient"
            }
            
            displayMessage(title: "Not all fields filled", message: errorMsg)
            
            return
        }
        
        if title == "Create Cocktail" {
            // Check if the cocktail exists
            if databaseController?.checkUniqueCocktailName(cocktail: newDraftCocktail) ?? false {
                let _ = databaseController?.addCocktailToGroup(cocktail: newDraftCocktail, group: databaseController!.defaultGroup)
                databaseController?.saveDraft()
                
                navigationController?.popToRootViewController(animated: false)
                return
            }

            // Alert
            displayMessage(title: "Cocktail already added", message: "Unable to add cocktail to list")
        } else if title == "Cocktail" {
            // Save the child context
            databaseController?.saveDraft()
            navigationController?.popViewController(animated: false)
            return
        }
        return
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_NAME:
                return 1
            case SECTION_INSTRUCTIONS:
                return 1
            case SECTION_INGREDIENTS_LIST:
                return newDraftCocktail.ingredients?.count ?? 0
            case SECTION_INGREDIENTS:
                return 1
            default:
                    return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case SECTION_NAME:
                return SECTION_NAME_HEADING
            case SECTION_INSTRUCTIONS:
                return SECTION_INSTRUCTIONS_HEADING
            case SECTION_INGREDIENTS_LIST:
                return SECTION_INGREDIENTS_LIST_HEADING
            default:
                return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_NAME {
            let nameCell = tableView.dequeueReusableCell(withIdentifier: CELL_NAME, for: indexPath)
            
            if newDraftCocktail.name == nil {
                // Prompt cell
                nameCell.textLabel?.text = "Enter name of cocktail"
                nameCell.textLabel?.textColor = .secondaryLabel
            } else {
                // Pre-filled cell
                nameCell.textLabel?.text = newDraftCocktail.name
                nameCell.textLabel?.textColor = .label
            }
            
            return nameCell
        } else if indexPath.section == SECTION_INSTRUCTIONS {
            let instructionCell = tableView.dequeueReusableCell(withIdentifier: CELL_INSTRUCTIONS, for: indexPath)
            
            if newDraftCocktail.instructions == nil {
                // Prompt cell
                instructionCell.textLabel?.text = "Enter instructions for making cocktail"
                instructionCell.textLabel?.textColor = .secondaryLabel
            } else {
                // Pre-filled cell
                instructionCell.textLabel?.text = newDraftCocktail.instructions
                instructionCell.textLabel?.textColor = .label
            }
            
            return instructionCell
        } else if indexPath.section == SECTION_INGREDIENTS_LIST {
            // Add ingredients measurement cells
            let ingredientsListCell = tableView.dequeueReusableCell(withIdentifier: CELL_INGREDIENTS_LIST, for: indexPath) as! IngredientsListTableViewCell
            
            let ingredient = newDraftCocktail.ingredients?.allObjects[indexPath.row] as! IngredientMeasurement
            
            ingredientsListCell.nameLabel?.text = ingredient.name
            ingredientsListCell.measurementLabel?.text = ingredient.quantity
            
            // Cannot select cell
            ingredientsListCell.selectionStyle = .none

            return ingredientsListCell
            
        } else if indexPath.section == SECTION_INGREDIENTS {
            // Prompt cell
            let ingredientsCell = tableView.dequeueReusableCell(withIdentifier: CELL_INGREDIENTS, for: indexPath)
            ingredientsCell.textLabel?.text = "Add ingredient"
            ingredientsCell.textLabel?.textColor = .secondaryLabel
            
            return ingredientsCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        // Only let ingredients list section be editable
        switch indexPath.section {
            case SECTION_INGREDIENTS_LIST:
                return true
            default:
                return false
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_INGREDIENTS_LIST {
            // Delete the row from the data source
            let ingredientToRemove = newDraftCocktail.ingredients?.allObjects[indexPath.row] as! IngredientMeasurement
            databaseController?.removeIngredientMeasurementFromCocktail(ingredientMeasurement: ingredientToRemove, cocktail: newDraftCocktail)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editNameSegue" {
            let destination = segue.destination as! EditNameViewController
            destination.nameDelegate = self
            
            // Pre-fill name text field
            if newDraftCocktail.name != nil {
                destination.name = newDraftCocktail.name
            }
        
        } else if segue.identifier == "editInstructionsSegue" {
            let destination = segue.destination as! EditInstructionsViewController
            destination.instructionsDelegate = self
            
            // Pre-fill instructions text field
            if newDraftCocktail.instructions != nil {
                destination.instructions = newDraftCocktail.instructions
            }
            
        } else if segue.identifier == "addIngredientSegue" {
            let destination = segue.destination as! AddIngredientViewController
            destination.ingredientDelegate = self
        }
    }
    
    // MARK: - NewCocktail Delegate
    func newName(name: String) -> Bool {
        // Can not be added
        if name == "" {
            return false
        }
        
        // Can be added
        newDraftCocktail.name = name
        return true
    }
    
    func newInstruction(instructions: String) -> Bool {
        // Can not be added
        if instructions == "" {
            return false
        }
        
        // Can be added
        newDraftCocktail.instructions = instructions
        return true
    }
    
    func newIngredientMeasurement(ingredientName: String, ingredientQuantity: String) -> Bool {
        // Can not be added
        if ingredientQuantity == "" {
            return false
        }
        
        // Can be added
        let _ = databaseController?.addIngredientMeasurementToCocktail(cocktail: newDraftCocktail, name: ingredientName, quantity: ingredientQuantity)
        return true
    }
    
    // MARK: - Alert
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
