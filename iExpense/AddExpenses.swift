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

    @State private var errorShow: Bool = false
    @State private var errorTitle: String = ""

    private let typesOfExpense = ["Business", "Personal"]
    var body: some View {
        NavigationStack {
            Form {
                Section {
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
                }
                if errorShow {
                    Section("Warning") {
                        Text(errorTitle)
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
            }.navigationTitle("Add expense").toolbar {
                Button("Save") {
                    addExpense()
                }
            }
        }
    }
    func addExpense() {
        guard !name.isEmpty else {
            error(title: "Please provide name of expense")
            return
        }
        guard amount > 0 else {
            error(title: "Please provide a valid amount greater than zero")
            return
        }
        let newExpense = ExpenseItem(
            name: name,
            type: type,
            amount: amount
        )

        expense.items.append(newExpense)
        dismiss()
    }
    func error(title: String) {
        errorTitle = title
        errorShow = true
    }
}

#Preview {
    AddExpenses(expense: Expense())
}
