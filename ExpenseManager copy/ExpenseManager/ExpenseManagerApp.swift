//
//  ExpenseManagerApp.swift
//  ExpenseManager
//
//  Created by admin on 03/02/25.
//

import SwiftUI

@main
struct ExpenseManagerApp: App {
    let persisteneceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext,persisteneceController.container.viewContext)
        }
    }
}
