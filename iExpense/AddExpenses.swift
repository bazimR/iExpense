//
//  AddExpenses.swift
//  iExpense
//
//  Created by Rishal Bazim on 23/02/25.
//

import SwiftUI

struct AddExpenses: View {
    @Environment(\.dismiss) var dismiss
    var expense: Expense

    @State private var name: String = ""
    @State private var type: String = "Personal"
    @State private var amount: Double = 0.0

    private let typesOfExpense = ["Business", "Personal"]
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense name", text: $name)
                Picker("Expense type", selection: $type) {
                    ForEach(typesOfExpense, id: \.self) {
                        Text($0)
                    }
                }
                TextField(
                    "Enter amount",
                    value: $amount,
                    format: .currency(
                        code: Locale.current.currency?.identifier ?? "USD")
                )
            }.navigationTitle("Add expense").toolbar {
                Button("Save") {
                    let newExpense = ExpenseItem(
                        name: name,
                        type: type,
                        amount: amount
                    )

                    expense.items.append(newExpense)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddExpenses(expense: Expense())
}
