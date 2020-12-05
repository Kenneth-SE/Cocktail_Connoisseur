//
//  EditInstructionsViewController.swift
//  kenneth-a2
//
//  Created by user160075 on 4/29/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class EditInstructionsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var instructionsTextField: UITextField!
    
    weak var instructionsDelegate: NewCocktailDelegate?
    
    var instructions: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        instructionsTextField.delegate = self
        
        // Set previous instructions if available
        if instructions != nil {
            instructionsTextField.text = instructions
        }
    }
    
    @IBAction func saveInstructions(_ sender: Any) {
        let instructions = instructionsTextField.text!
            
        // Use the delegate to add to the previous view
        if instructionsDelegate?.newInstruction(instructions: instructions) ?? false {
            navigationController?.popViewController(animated: true)
            return
        }
        
        // Display alert if instructions not provided
        let errorMsg = "Please ensure all fields are filled:\n- Must provide instructions"
        displayMessage(title: "Not all fields filled", message: errorMsg)
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
