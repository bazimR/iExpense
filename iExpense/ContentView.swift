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

enum Routes: Hashable, Codable {
    case add
}

@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }

    let savedPath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        if let data = try? Data(contentsOf: savedPath) {
            if let decoded = try? JSONDecoder().decode(
                NavigationPath.CodableRepresentation.self,
                from: data
            ) {
                path = NavigationPath(decoded)
                return
            }
        }
        path = NavigationPath()
    }

    func save() {
        guard let representation = path.codable else { return }
        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savedPath)
        } catch {
            print("Error saving nav data.")
        }
    }

}

@Observable
class Expense {
    var itemsBusiness: [ExpenseItem] = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(itemsBusiness) {
                UserDefaults.standard.set(encoded, forKey: "ItemsBusiness")
            }
        }
    }
    var itemsPersonal: [ExpenseItem] = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(itemsPersonal) {
                UserDefaults.standard.set(encoded, forKey: "ItemsPersonal")
            }
        }
    }
    init() {
        if let saveItemsBusiness = UserDefaults.standard.data(
            forKey: "ItemsBusiness")
        {
            if let decodedItems = try? JSONDecoder().decode(
                [ExpenseItem].self,
                from: saveItemsBusiness
            ) {
                itemsBusiness = decodedItems
            }
        } else {
            itemsBusiness = []
        }

        if let saveItemsPersonal = UserDefaults.standard.data(
            forKey: "ItemsPersonal")
        {
            if let decodedItems = try? JSONDecoder().decode(
                [ExpenseItem].self,
                from: saveItemsPersonal
            ) {
                itemsPersonal = decodedItems
            }
        } else {
            itemsPersonal = []
        }
    }

}
struct ContentView: View {
    @State private var expense = Expense()
    @State private var pathStore = PathStore()
    var body: some View {
        NavigationStack(path: $pathStore.path) {
            List {
                Section("Personal Expenses") {
                    if expense.itemsPersonal.isEmpty {
                        Text("No Personal expenses logged.")
                    } else {
                        ForEach(
                            expense.itemsPersonal
                        ) { item in
                            ItemView(item: item)
                        }.onDelete(perform: removeItemsPersonal)
                    }
                }
                Section("Business Expenses") {
                    if expense.itemsBusiness.isEmpty {
                        Text("No Business expenses logged.")
                    } else {
                        ForEach(
                            expense.itemsBusiness
                        ) { item in
                            ItemView(item: item)
                        }.onDelete(perform: removeItemsBusiness)
                    }
                }
            }.navigationTitle("iExpense").toolbar {
                Button("Add Expense", systemImage: "plus") {
                    print(
                        "Before navigation, path count: \(pathStore.path.count)"
                    )
                    pathStore.path.append(Routes.add)
                    print(
                        "After navigation, path count: \(pathStore.path.count)")
                }
            }.navigationDestination(for: Routes.self) { route in
                switch route {
                case .add:
                    AddExpenses(expense: expense, path: $pathStore.path)
                }
            }
        }
    }
    func removeItemsBusiness(at offset: IndexSet) {
        expense.itemsBusiness.remove(atOffsets: offset)
    }
    func removeItemsPersonal(at offset: IndexSet) {
        expense.itemsPersonal.remove(atOffsets: offset)
    }
}

#Preview {
    ContentView()
}
