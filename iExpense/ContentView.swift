//
//  ContentView.swift
//  iExpense
//
//  Created by Rishal Bazim on 23/02/25.
//

import SwiftData
import SwiftUI

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

struct ContentView: View {
    @State private var pathStore = PathStore()

    @State private var sortOrder = [SortDescriptor(\Expense.name)]

    @State private var typeSwitch: String = "Personal"
    var body: some View {
        NavigationStack(path: $pathStore.path) {
            ExpenseListView(sortOrder: sortOrder, type: typeSwitch)
                .navigationTitle("iExpense")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {  // Separate ToolbarItem for Menu
                        Menu {
                            Picker("Sort by", selection: $sortOrder) {
                                Text("Name").tag([SortDescriptor(\Expense.name)]
                                )
                                Text("Amount").tag([
                                    SortDescriptor(\Expense.amount)
                                ])
                            }
                        } label: {
                            Label("Sort", systemImage: "arrow.up.arrow.down")
                        }
                    }

                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            pathStore.path.append(Routes.add)
                        } label: {
                            Label("Add Expense", systemImage: "plus")
                        }
                        Button(
                            typeSwitch == "Business" ? "Personal" : "Business"
                        ) {
                            withAnimation(.easeInOut) {
                                if typeSwitch == "Personal" {
                                    typeSwitch = "Business"
                                } else {
                                    typeSwitch = "Personal"
                                }
                            }
                        }
                    }

                }.navigationDestination(for: Routes.self) { route in
                    switch route {
                    case .add:
                        AddExpenses(path: $pathStore.path)
                    }
                }
        }
    }

}

#Preview {
    ContentView().modelContainer(for: Expense.self, inMemory: true)
}
