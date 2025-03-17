//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Rishal Bazim on 23/02/25.
//

import SwiftData
import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Expense.self)
    }
}
