//
//  ExpensesListViewController.swift
//  ExpensesApp
//
//  Created by Aldo Ruiz Parra on 8/5/25.
//

import UIKit

struct Expense {
    let title: String
    let amount: String
}


class ExpensesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var expenses: [Expense] = []

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addVC = storyboard.instantiateViewController(withIdentifier: "AddExpenseViewController") as? AddExpenseViewController {
            addVC.onSave = { [weak self] expense in
                self?.expenses.append(expense)
                self?.tableView.reloadData()
            }
            present(addVC, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If you embedded Add screen in a nav controller, unwrap it:
        if let nav = segue.destination as? UINavigationController,
           let addVC = nav.topViewController as? AddExpenseViewController {
            addVC.onSave = { [weak self] e in
                self?.expenses.append(e)
                self?.tableView.reloadData()
                // (Optional) persist here
            }
        } else if let addVC = segue.destination as? AddExpenseViewController {
            addVC.onSave = { [weak self] e in
                self?.expenses.append(e)
                self?.tableView.reloadData()
            }
        }
    }

    
    override func viewDidLoad() {
           super.viewDidLoad()
           title = "Expenses"
           tableView.dataSource = self
           tableView.delegate = self
       }

        
       // MARK: - TableView Data Source
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return expenses.count
       }

    
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
           let expense = expenses[indexPath.row]
           cell.textLabel?.text = "\(expense.title) - \(expense.amount)"
           return cell
       }
}

    

