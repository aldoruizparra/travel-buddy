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
    @IBOutlet weak var owedByTextField: UITextField!
    @IBOutlet weak var owedToTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    
    var onSave: ((Expense) -> Void)?
    
    // If set, view is in "edit" mode
    var expenseToEdit: Expense?
    
    private let datePicker = UIDatePicker()
      private let dateFormatter: DateFormatter = {
          let f = DateFormatter()
          f.dateStyle = .medium
          f.timeStyle = .none
          return f
      }()
      private var selectedDate = Date()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatePicker() 
        // Prefill when editing
        if let e = expenseToEdit {
            titleTextField.text = e.title
            amountTextField.text = e.amount
            owedToTextField.text = e.owedTo
            owedByTextField.text = e.owedBy
            noteTextView.text   = e.note
            selectedDate         = e.date
            title = "Edit Expense"
        } else {
            title = "Add Expense"
            selectedDate         = Date()
        }
        
        // Reflect selectedDate into UI + picker
        datePicker.setDate(selectedDate, animated: false)
        dateTextField.text = dateFormatter.string(from: selectedDate)
    }
    
    private func configureDatePicker() {
            datePicker.datePickerMode = .date
            if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
            // Optional: prevent future dates for expenses
            datePicker.maximumDate = Date()
            datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
            dateTextField.inputView = datePicker

            // Toolbar with Today/Done
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let today = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(setToday))
            let flex  = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done  = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicking))
            toolbar.items = [today, flex, done]
            dateTextField.inputAccessoryView = toolbar
        }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc private func setToday() {
        selectedDate = Date()
        datePicker.setDate(selectedDate, animated: true)
        dateTextField.text = dateFormatter.string(from: selectedDate)
    }
    @objc private func donePicking() { dateTextField.resignFirstResponder() }

    
    @IBAction func closedTapped(_ sender: UIButton) {
        // Discard changes and close
        closeSelf()
    }
    @IBAction func saveTapped(_ sender: UIButton) {
        // Validate title
       guard let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
             !title.isEmpty else {
           presentAlert(title: "Oops…", message: "Please enter a title.")
           return
       }

     
       guard let amountText = amountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
             let amount = Double(amountText) else {
           presentAlert(title: "Oops…", message: "Please enter a valid amount (e.g. 12.50).")
           return
       }

       let newExpense = Expense(
           title: title,
           amount: String(amount),
           owedTo: emptyToNil(owedToTextField.text),
           owedBy: emptyToNil(owedByTextField.text),
           note:   noteTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true ? nil : noteTextView.text,
           date:   selectedDate
       )

       onSave?(newExpense)
       closeSelf()
    }
    
    private func closeSelf() {
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

    private func emptyToNil(_ s: String?) -> String? {
       let t = s?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
       return t.isEmpty ? nil : t
    }
}
