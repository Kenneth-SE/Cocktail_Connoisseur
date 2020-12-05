//
//  EditNameViewController.swift
//  kenneth-a2
//
//  Created by user160075 on 4/29/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class EditNameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var nameDelegate: NewCocktailDelegate?
    
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        
        // Set previous name if available
        if name != nil {
            nameTextField.text = name
        }
    }
    
    @IBAction func saveName(_ sender: Any) {
        let name = nameTextField.text!
        
        // Use the delegate to add to the previous view
        if nameDelegate?.newName(name: name) ?? false {
            navigationController?.popViewController(animated: true)
            return
        }
        
        // Display alert if name not provided
        let errorMsg = "Please ensure all fields are filled:\n- Must provide a name"
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
