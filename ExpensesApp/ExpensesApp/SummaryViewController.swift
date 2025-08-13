//
//  SummaryViewController.swift
//  ExpensesApp
//
//  Created by Aldo Ruiz Parra on 8/12/25.
//
import UIKit


final class SummaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var summaryTableView: UITableView!
    
    private let currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        return f
    }()

    // Keep this string EXACTLY the same as in ExpensesListViewController
    private let expensesKey = "expenses_v1"

    private var expenses: [Expense] = []

    // Computed summaries
    private var totalsByPair: [PairKey: Double] = [:]
    private var totalsByDebtor: [String: Double] = [:]

    private enum Section: Int, CaseIterable {
        case byPair = 0
        case byPerson = 1
    }

    private struct PairKey: Hashable {
        let by: String
        let to: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Summary"

        summaryTableView.dataSource = self
        summaryTableView.delegate = self

        // Basic cell
        summaryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        loadExpenses()
        recompute()

        // Listen for changes from the Expenses tab
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(expensesChanged),
                                               name: .expensesChanged,
                                               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // In case the user switched tabs without a save notification (edge cases)
        loadExpenses()
        recompute()
        summaryTableView.reloadData()
    }

    @objc private func expensesChanged() {
        loadExpenses()
        recompute()
        summaryTableView.reloadData()
    }

    private func loadExpenses() {
        guard let data = UserDefaults.standard.data(forKey: expensesKey) else {
            expenses = []
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            expenses = try decoder.decode([Expense].self, from: data)
        } catch {
            print("Failed to decode expenses:", error)
            expenses = []
        }
    }

    private func recompute() {
        totalsByPair.removeAll()
        totalsByDebtor.removeAll()

        for e in expenses {
            guard let by = e.owedBy?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let to = e.owedTo?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !by.isEmpty, !to.isEmpty,
                  let amt = Double(e.amount)
            else { continue }

            // Sum per pair (Alice → Bob)
            let key = PairKey(by: by, to: to)
            totalsByPair[key, default: 0] += amt

            // Sum total each person owes (as debtor)
            totalsByDebtor[by, default: 0] += amt
        }
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = Section(rawValue: section) else { return 0 }
        switch sec {
        case .byPair:
            return totalsByPair.count
        case .byPerson:
            return totalsByDebtor.count
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sec = Section(rawValue: section) else { return nil }
        switch sec {
        case .byPair:
            return "Who owes whom"
        case .byPerson:
            return "Total owed by person"
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = summaryTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        guard let sec = Section(rawValue: indexPath.section) else { return cell }

        switch sec {
        case .byPair:
            let items = totalsByPair.sorted { a, b in
                if a.key.by == b.key.by { return a.key.to < b.key.to }
                return a.key.by < b.key.by
            }
            let entry = items[indexPath.row]
            let amountText = currencyFormatter.string(from: NSNumber(value: entry.value)) ?? String(entry.value)
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.text = "\(entry.key.by) → \(entry.key.to)\n\(amountText)"

        case .byPerson:
            let items = totalsByDebtor.sorted { a, b in
                if a.value == b.value { return a.key < b.key }
                return a.value > b.value
            }
            let entry = items[indexPath.row]
            let amountText = currencyFormatter.string(from: NSNumber(value: entry.value)) ?? String(entry.value)
            cell.textLabel?.text = "\(entry.key) owes \(amountText) total"
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let h = view as? UITableViewHeaderFooterView {
            h.textLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        }
    }
}
