//
//  Person.swift
//  FaceFacts
//
//  Created by Brad Siegel on 2/27/24.
//

import Foundation
import SwiftData

@Model
class Person {
    var name: String
    var emailAddress: String
    var details: String
    // A connection is automatically created between Person and Event. No need to add the Event object to the modelContainer.
    // This is done automatically.
    //
    // Will do a DB migration automatically
    var metAt: Event?
    @Attribute(.externalStorage) var photo: Data?
    
    init(name: String, emailAddress: String, details: String, metAt: Event? = nil) {
        self.name = name
        self.emailAddress = emailAddress
        self.details = details
        self.metAt = metAt
    }
}
