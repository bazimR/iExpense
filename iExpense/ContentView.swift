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
                ForEach(expense.items) { item in
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
                        ).font(.title3)
                    }
                }.onDelete(perform: removeItems)
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
