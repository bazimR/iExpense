//
//  AddExpenses.swift
//  iExpense
//
//  Created by Rishal Bazim on 23/02/25.
//

import SwiftUI

struct AddExpenses: View {
    var expense: Expense
    @Binding var path: NavigationPath
    @State private var name: String = ""
    @State private var type: String = "Personal"
    @State private var amount: Double = 0.0

    @State private var errorShow: Bool = false
    @State private var errorTitle: String = ""

    private let typesOfExpense = ["Business", "Personal"]
    var body: some View {
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
            ToolbarItemGroup {
                Button("Cancel") {
                    path.removeLast()
                }
                Button("Save") {
                    addExpense()

                }
            }
        }.navigationBarBackButtonHidden()
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

        if type == "Personal" {
            expense.itemsPersonal.append(newExpense)
        } else {
            expense.itemsBusiness.append(newExpense)
        }
        path.removeLast()
    }
    func error(title: String) {
        errorTitle = title
        errorShow = true
    }
}

#Preview {
    @Previewable @State var previewPathStore = PathStore()
    AddExpenses(expense: Expense(), path: $previewPathStore.path)
}
