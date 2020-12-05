//
//  SearchCocktailsTableViewController.swift
//  kenneth-a2
//
//  Created by user160075 on 4/29/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class SearchCocktailsTableViewController: UITableViewController, UISearchBarDelegate {
    
    // Constants
    let SECTION_DRINKS = 0
    let SECTION_INFO = 1
    let CELL_DRINKS = "cocktailCell"
    let CELL_INFO = "totalDrinksCell"
    let REQUEST_STRING = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s="
    
    var indicator = UIActivityIndicatorView()
    var newDrinks = [DrinksSearch]()

    var initialEntry: Bool = false
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // Search controller setup
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cocktails"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // This view controller decides how the search controller is presented
        definesPresentationContext = true
        
        // Create a loading animation
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.tableView.center
        self.view.addSubview(indicator)
    }
    
    // MARK: - Search Bar Delegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // If there is no text end immediately
        guard let searchText = searchBar.text, searchText.count > 0 else {
            return;
        }

        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        
        // Allow the prompt to show
        initialEntry = false
        
        // Query the web API and reload the table
        newDrinks.removeAll()
        requestCocktails(cocktailName: searchText)
        tableView.reloadData()
    }
    
     // MARK: - Web Request

    func requestCocktails(cocktailName: String) {

        let searchString = REQUEST_STRING + cocktailName
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let task = URLSession.shared.dataTask(with: jsonURL!) { (data, response, error) in
            // Regardless of response end the loading icon from the main thread
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
            
            if let error = error {
                print(error)
                return
            }
            
            // Decode web API call
            do {
                let decoder = JSONDecoder()
                let drinkData = try decoder.decode(DrinkData.self, from: data!)
                if let drinks = drinkData.drinks {
                    
                    self.newDrinks.append(contentsOf: drinks)

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_DRINKS && newDrinks.count > 0 {
            return newDrinks.count
        } else if section == SECTION_INFO && newDrinks.count == 0 && !initialEntry {
            return 1
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SECTION_DRINKS {
            // Set up cell with cocktail data
            let cocktailCell = tableView.dequeueReusableCell(withIdentifier: CELL_DRINKS, for: indexPath) as! CocktailTableViewCell
            
            cocktailCell.nameLabel.text = newDrinks[indexPath.row].name
            cocktailCell.instructionsLabel.text = newDrinks[indexPath.row].instructions
            
            return cocktailCell
        } else if indexPath.section == SECTION_INFO && newDrinks.count == 0 {
            // Prompt text
            let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
            
            infoCell.textLabel?.text = "No matching drinks.\nTap to enter a new one."
            infoCell.textLabel?.textColor = .secondaryLabel
            infoCell.selectionStyle = .none
                
            return infoCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_INFO {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        
        // Create a new cocktail from the selected row
        let newCocktail = databaseController?.addCocktail(name: newDrinks[indexPath.row].name!, instructions: newDrinks[indexPath.row].instructions!)
        
        // Add all ingredient measurements to the new cocktail
        let ingredientMeasurements = newDrinks[indexPath.row].ingredientMeasurements
        for ingredientMeasurement in ingredientMeasurements {
            let _ = databaseController?.addIngredientMeasurementToCocktail(cocktail: newCocktail!, name: ingredientMeasurement[0], quantity: ingredientMeasurement[1])
        }
        
        // Check if the cocktail exists in the default group
        if databaseController?.checkUniqueCocktailName(cocktail: newCocktail!) ?? false {
            let _ = databaseController?.addCocktailToGroup(cocktail: newCocktail!, group: databaseController!.defaultGroup)
                       
            navigationController?.popViewController(animated: false)
            return
        }
        
        // Alert if cocktail already exists
        tableView.deselectRow(at: indexPath, animated: true)
        displayMessage(title: "Cocktail already added", message: "Unable to add cocktail to list")
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "createCocktailSegue" {
            let destination = segue.destination as! CreateCocktailTableViewController
            destination.title = "Create Cocktail"
            
            // Set empty cocktail
            destination.newDraftCocktail = databaseController!.createNewDraftCocktail()
        }
    }
    
    // MARK: - Alert
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
