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
    let owedTo: String?
    let owedBy: String?
    let note: String?
    let date: Date
}

private let currencyFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.numberStyle = .currency
    return f
}()

private let dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "MMM d, yyyy"   // e.g., “Aug 10, 2025”
    return f
}()


class ExpensesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var expenses: [Expense] = []
    // Track which row is being edited
    private var editingIndexPath: IndexPath?

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        editingIndexPath = nil
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addVC = storyboard.instantiateViewController(withIdentifier: "AddExpenseViewController") as? AddExpenseViewController else { return }

           addVC.expenseToEdit = nil     // (explicit)
           addVC.onSave = { [weak self] expense in
               self?.expenses.append(expense)
               self?.tableView.reloadData()
           }
           present(addVC, animated: true)

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

    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return expenses.count
   }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        let e = expenses[indexPath.row]

        // Title + subtitle you already build...
        var parts: [String] = []
        if let by = e.owedBy, let to = e.owedTo, !by.isEmpty, !to.isEmpty {
            parts.append("\(by) → \(to)")
        } else if let by = e.owedBy, !by.isEmpty {
            parts.append("Owed by \(by)")
        } else if let to = e.owedTo, !to.isEmpty {
            parts.append("Owed to \(to)")
        }
        parts.append(dateFormatter.string(from: e.date))

        var content = cell.defaultContentConfiguration()
        content.text = e.title
        content.textProperties.font = .systemFont(ofSize: 17, weight: .semibold)
        content.secondaryText = parts.joined(separator: " • ")
        content.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration = content

        let amountDouble = Double(e.amount) ?? 0
        let amountText = currencyFormatter.string(from: NSNumber(value: amountDouble)) ?? e.amount

        let amountLabel: UILabel
        if let lbl = cell.accessoryView as? UILabel {
            amountLabel = lbl
        } else {
            let lbl = UILabel()
            lbl.font = .monospacedDigitSystemFont(ofSize: 17, weight: .semibold)
            lbl.textAlignment = .right
            cell.accessoryView = lbl
            amountLabel = lbl
        }
        amountLabel.text = amountText
        amountLabel.sizeToFit()


        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)  // ← add this
        let sb = UIStoryboard(name: "Main", bundle: nil)
       guard let addVC = sb.instantiateViewController(withIdentifier: "AddExpenseViewController") as? AddExpenseViewController else { return }

       editingIndexPath = indexPath
       addVC.expenseToEdit = expenses[indexPath.row]

       addVC.onSave = { [weak self] updated in
           guard let self, let idx = self.editingIndexPath?.row else { return }
           self.expenses[idx] = updated
           self.tableView.reloadRows(at: [IndexPath(row: idx, section: 0)], with: .automatic)
       }

       present(addVC, animated: true)
    }
    
    // Enable swipe actions: Delete (and optional Edit)
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, done in
            guard let self else { return }
            self.deleteExpense(at: indexPath)
            done(true)
        }

        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, done in
            guard let self else { return }
            self.tableView(self.tableView, didSelectRowAt: indexPath) // reuse your tap-to-edit
            done(true)
        }
        edit.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    private func deleteExpense(at indexPath: IndexPath) {
        // Optional: confirm first
        let e = expenses[indexPath.row]
        let ac = UIAlertController(title: "Delete expense?",
                                   message: "“\(e.title)” will be removed.",
                                   preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.expenses.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            // TODO: persist if you’re saving to disk (e.g., self.saveExpenses())
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}

    

