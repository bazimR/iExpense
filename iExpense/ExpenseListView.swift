//
//  ExpenseListView.swift
//  iExpense
//
//  Created by Rishal Bazim on 18/03/25.
//

import SwiftData
import SwiftUI

struct ItemView: View {
    let item: Expense
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name).font(.headline)
                Text(item.type)
            }
            Spacer()
            Text(
                item.amount,
                format:
                    .currency(
                        code: Locale.current.currency?.identifier
                            ?? "USD")
            ).font(.title3.bold()).foregroundColor(item.color)
        }
    }
}
struct ExpenseListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var expenseList: [Expense]
    var type: String
    var body: some View {
        List {
            ForEach(expenseList) { expense in
                ItemView(item: expense)
            }.onDelete { IndexSet in
                IndexSet.forEach { Index in
                    let item = expenseList[Index]
                    modelContext.delete(item)
                }
            }
        }.overlay(
            content: {
                if expenseList.isEmpty {
                    ContentUnavailableView(
                        "No \(type) expenses",
                        systemImage: "list.bullet",
                        description: Text("Add new expenses to list here.")
                    )
                }
            })
    }
    init(sortOrder: [SortDescriptor<Expense>], type: String) {
        _expenseList = Query(
            filter: #Predicate<Expense> { expense in
                expense.type == type
            },
            sort: sortOrder)

        self.type = type
    }
}

#Preview {
    ExpenseListView(
        sortOrder: [SortDescriptor(\Expense.name)], type: "Business")
}
