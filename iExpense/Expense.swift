//
//  Expense.swift
//  iExpense
//
//  Created by Rishal Bazim on 18/03/25.
//

import SwiftData
import SwiftUI

@Model
class Expense {
    var name: String
    var type: String
    var amount: Double
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }

    var color: Color {
        switch amount {
        case 1000.00...:
            .red
        case 500.00...1000.00:
            .orange
        case 200.00...500.00:
            .yellow
        default:
            .green
        }
    }
}
