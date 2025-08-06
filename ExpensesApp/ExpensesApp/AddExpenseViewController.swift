//
//  AddExpenseViewController.swift
//  
//
//  Created by Aldo Ruiz Parra on 8/5/25.
//

import UIKit

class AddExpenseViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    var onSave: ((Expense) -> Void)?
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty,
                     let amount = amountTextField.text, !amount.isEmpty else { return }
               
        let newExpense = Expense(title: title, amount: amount)
        onSave?(newExpense)
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
