//
//  DiceRollApp.swift
//  DiceRoll
//
//  Created by Andrew Almasi on 8/16/22.
//

import SwiftUI

@main
struct DiceRollApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                              dataController.container.viewContext)
        }
    }
}
