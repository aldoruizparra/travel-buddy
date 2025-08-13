//
//  Expense.swift
//  ExpensesApp
//
//  Created by Aldo Ruiz Parra on 8/11/25.
//

import Foundation

struct Expense: Codable, Equatable {
    var title: String
    var amount: String
    var owedTo: String?
    var owedBy: String?
    var note: String?
    var date: Date
    var location: String?
}
