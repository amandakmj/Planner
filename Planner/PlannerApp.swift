//
//  PlannerApp.swift
//  Planner
//
//  Created by Amanda Silva Araujo on 20/04/25.
//

import SwiftUI

@main
struct PlannerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
