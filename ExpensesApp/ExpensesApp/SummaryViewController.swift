//
//  SummaryViewController.swift
//  ExpensesApp
//
//  Created by Aldo Ruiz Parra on 8/12/25.
//
import UIKit


class SummaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var summaryTableView: UITableView!
    private let currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        return f
    }()

    // Must match the key used in ExpensesListViewController
    private let expensesKey = "expenses_v1"

    private var expenses: [Expense] = []

    // Parsed net settlements (debtor -> creditor)
    private struct Transfer {
        let from: String
        let to: String
        let amount: Double
    }
    private var settlements: [Transfer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Summary"

        summaryTableView.dataSource = self
        summaryTableView.delegate = self
        summaryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        loadExpenses()
        recompute()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(expensesChanged),
                                               name: .expensesChanged,
                                               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadExpenses()
        recompute()
        summaryTableView.reloadData()
    }

    deinit { NotificationCenter.default.removeObserver(self) }

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

    // More forgiving amount parser (handles "1,234.56")
    private let parseFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()
    private func parseAmount(_ s: String) -> Double? {
        if let n = parseFormatter.number(from: s) { return n.doubleValue }
        return Double(s)
    }

    
    private func recompute() {
        // 1) Compute net balance per person
        //    owedBy (debtor) -= amount, owedTo (creditor) += amount
        var balances: [String: Double] = [:]

        for e in expenses {
            guard let by = e.owedBy?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let to = e.owedTo?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !by.isEmpty, !to.isEmpty,
                  let amt = parseAmount(e.amount), amt > 0
            else { continue }

            balances[by, default: 0] -= amt
            balances[to, default: 0] += amt
        }

        // 2) Split into debtors/creditors and greedily match to get net settlements
        var debtors: [(name: String, amount: Double)] = []   // positive amount they owe
        var creditors: [(name: String, amount: Double)] = [] // positive amount they’re owed

        for (name, bal) in balances {
            if bal < -0.0001 { debtors.append((name, -bal)) }
            else if bal > 0.0001 { creditors.append((name, bal)) }
        }

        debtors.sort { $0.amount > $1.amount }
        creditors.sort { $0.amount > $1.amount }

        settlements.removeAll()
        var i = 0, j = 0
        while i < debtors.count && j < creditors.count {
            let pay = min(debtors[i].amount, creditors[j].amount)
            if pay > 0.0001 {
                settlements.append(Transfer(from: debtors[i].name, to: creditors[j].name, amount: pay))
            }
            debtors[i].amount  -= pay
            creditors[j].amount -= pay
            if debtors[i].amount  <= 0.0001 { i += 1 }
            if creditors[j].amount <= 0.0001 { j += 1 }
        }

        // Empty state when nothing is owed
        if settlements.isEmpty {
            let label = UILabel()
            label.text = "All settled up!"
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            summaryTableView.backgroundView = label
        } else {
            summaryTableView.backgroundView = nil
        }
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settlements.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Net balances"
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = summaryTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let t = settlements[indexPath.row]

        if #available(iOS 14.0, *) {
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(t.from) → \(t.to)"
            content.secondaryText = currencyFormatter.string(from: NSNumber(value: t.amount))
            content.prefersSideBySideTextAndSecondaryText = true
            cell.contentConfiguration = content
        } else {
            let amt = currencyFormatter.string(from: NSNumber(value: t.amount)) ?? String(t.amount)
            cell.textLabel?.text = "\(t.from) → \(t.to): \(amt)"
        }

        cell.selectionStyle = .none
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
    }
}

