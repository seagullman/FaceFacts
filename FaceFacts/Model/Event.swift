//
//  Event.swift
//  FaceFacts
//
//  Created by Brad Siegel on 2/27/24.
//

import Foundation
import SwiftData

@Model
class Event {
    var name: String
    var location: String
    var people = [Person]()
    
    init(name: String, location: String) {
        self.name = name
        self.location = location
    }
}
