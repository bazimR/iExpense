//
//  ContentView.swift
//  iExpense
//
//  Created by Rishal Bazim on 23/02/25.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    let type: String
    let amount: Double
}

struct ItemView: View {
    let item: ExpenseItem
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
            ).font(.title3.bold()).foregroundColor(
                item.amount > 99
                    ? .red : item.amount > 49 ? .yellow : .green)
        }
    }
}

@Observable
class Expense {
    var items: [ExpenseItem] = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }

    init() {
        if let saveItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode(
                [ExpenseItem].self,
                from: saveItems
            ) {
                items = decodedItems
            }
        } else {
            items = []
        }

    }
}
struct ContentView: View {
    @State private var expense = Expense()
    @State private var showAddExpense: Bool = false
    var body: some View {
        NavigationStack {
            List {
                Section("Personal Expenses") {
                    if (expense.items.filter { $0.type == "Personal" }).isEmpty
                    {
                        Text("No Personal expenses logged.")
                    } else {
                        ForEach(
                            expense.items.filter { item in
                                return item.type == "Personal"
                            }
                        ) { item in
                            ItemView(item: item)
                        }.onDelete(perform: removeItems)
                    }
                }
                Section("Business Expenses") {
                    if (expense.items.filter { $0.type == "Business" }).isEmpty
                    {
                        Text("No Business expenses logged.")
                    } else {
                        ForEach(
                            expense.items.filter { item in
                                return item.type == "Business"
                            }
                        ) { item in
                            ItemView(item: item)
                        }.onDelete(perform: removeItems)
                    }
                }
            }.navigationTitle("iExpense").toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showAddExpense = true
                }
            }.sheet(isPresented: $showAddExpense) {
                AddExpenses(expense: expense)
            }
        }
    }
    func removeItems(at offset: IndexSet) {
        expense.items.remove(atOffsets: offset)
    }
}

#Preview {
    ContentView()
}
