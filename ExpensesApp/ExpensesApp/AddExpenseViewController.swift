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
        // Validate title
             guard let title = titleTextField.text, !title.isEmpty else {
                 presentAlert(title: "Oops…", message: "Please enter a title.")
                 return
             }
             // Validate amount as a number
             guard let amountText = amountTextField.text,
                   let amount = Double(amountText) else {
                 presentAlert(title: "Oops…", message: "Please enter a valid amount (e.g. 12.50).")
                 return
             }

            let newExpense = Expense(title: title, amount: String(amount))
             onSave?(newExpense)

             // Close depending on how this screen was shown
             if presentingViewController != nil {
                 dismiss(animated: true)
             } else {
                 navigationController?.popViewController(animated: true)
             }
    }
    private func presentAlert(title: String, message: String) {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//    

}
