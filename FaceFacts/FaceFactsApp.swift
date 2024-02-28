//
//  FaceFactsApp.swift
//  FaceFacts
//
//  Created by Brad Siegel on 2/27/24.
//

import SwiftUI
import SwiftData

@main
struct FaceFactsApp: App {
    var body: some Scene {
        WindowGroup {
            PersonListView()
        }
        .modelContainer(for: Person.self) // Uses CoreData which uses SQLite behind the curtains
        // This automatically makes a model context for you and places it into the Swift environment.
    }
}
