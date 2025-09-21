//
//  GroceryTrackerApp.swift
//  GroceryTracker
//
//  Created by Prithvij Rajesh on 9/21/25.
//

import SwiftUI
import CoreData

@main
struct GroceryTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
