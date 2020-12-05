//
//  MyDrinksTableViewController.swift
//  kenneth-a2
//
//  Created by user160075 on 4/28/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class MyDrinksTableViewController: UITableViewController, DatabaseListener {
    
    let SECTION_DRINKS = 0;
    let SECTION_INFO = 1;
    let CELL_COCKTAIL = "cocktailCell"
    let CELL_INFO = "totalDrinksCell"
    
    var currentDrinks: [Cocktail] = []
    var selectedIndexPath: IndexPath = IndexPath()
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .group

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        currentDrinks = cocktailGroup
        tableView.reloadData()
    }
    
    func onIngredientGroup(change: DatabaseChange, ingredients: [Ingredient]) {
        // Do nothing not called
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_DRINKS:
                return currentDrinks.count
            case SECTION_INFO:
                return 1
        default:
                return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fill cell with cocktail details
        if indexPath.section == SECTION_DRINKS {
            let drinkCell = tableView.dequeueReusableCell(withIdentifier: CELL_COCKTAIL, for: indexPath) as! CocktailTableViewCell
            let drink = currentDrinks[indexPath.row]

            drinkCell.nameLabel?.text = drink.name
            drinkCell.instructionsLabel?.text = drink.instructions

            return drinkCell
        }
        
        // Prompt cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        
        cell.textLabel?.textColor = .secondaryLabel
        cell.selectionStyle = .none
        if currentDrinks.count > 1 {
            cell.textLabel?.text = "\(currentDrinks.count) saved drinks"
        } else if currentDrinks.count == 1 {
            cell.textLabel?.text = "\(currentDrinks.count) saved drink"
        } else {
            cell.textLabel?.text = "No drinks available. Click + to add some"
        }
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        // Allow drink section to be edited
        switch indexPath.section {
        case SECTION_DRINKS:
            return true
        default:
            return false
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Remove cocktail from default group
        if editingStyle == .delete && indexPath.section == SECTION_DRINKS {
            self.databaseController!.removeCocktailFromGroup(cocktail: currentDrinks[indexPath.row], group: databaseController!.defaultGroup)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "searchCocktailsSegue" {
            let destination = segue.destination as! SearchCocktailsTableViewController
            destination.initialEntry = true
            
        } else if segue.identifier == "editCocktailSegue" {
            let destination = segue.destination as! CreateCocktailTableViewController
            destination.title = "Cocktail"
            
            // Set the draft cocktail to be the selected cocktail
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedCocktail = currentDrinks[indexPath.row]
                
                destination.newDraftCocktail = databaseController?.createCocktailDraft(from: selectedCocktail) as! Cocktail
            }
        }
    }
}
