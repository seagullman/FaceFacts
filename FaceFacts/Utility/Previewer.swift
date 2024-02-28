//
//  Previewer.swift
//  FaceFacts
//
//  Created by Brad Siegel on 2/27/24.
//

import Foundation
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let event: Event
    let person: Person
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Person.self, configurations: config)
        
        event = Event(name: "re:Invent", location: "Las Vegas")
        person = Person(name: "John", emailAddress: "Smith", details: "Nice guy")
        
        container.mainContext.insert(person) // This struct is marked @MainActor so that it can easily access the mainContext
    }
}
