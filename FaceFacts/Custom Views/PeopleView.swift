//
//  PeopleView.swift
//  FaceFacts
//
//  Created by Brad Siegel on 2/27/24.
//

import SwiftUI
import SwiftData

struct PeopleView: View {
    // ModelContext is like a Cache for SwiftData. Uses batching to write to disk to maximize
    // efficiency
    @Environment(\.modelContext) var modelContext
    // @Query tells the model container to "give me all the Person objects you
    // are managing"
    //
    // This is kept up to date, so if an objected is updated, added or deleted,
    // the view will be re-loaded automatically
    @Query var people: [Person]
    
    var body: some View {
        List {
            ForEach(people) { person in
                NavigationLink(value: person) {
                    Label(person.name, systemImage: "person")
                }
            }
            .onDelete(perform: deletePerson)
        }
    }
    
    init(searchString: String = "", sortOrder: [SortDescriptor<Person>] = []) {
        // _people is of the underlying type. It accesses the Query object
        _people = Query(filter: #Predicate { person in
            if searchString.isEmpty {
                true
            } else {
                // localizedStandardContains ignores case by default
                // these are checked in order. Put search that is most likely to eliminate users
                // first 
                person.name.localizedStandardContains(searchString) ||
                person.emailAddress.localizedStandardContains(searchString) ||
                person.details.localizedStandardContains(searchString)
            }
        }, sort: sortOrder)
    }
    
    func deletePerson(at offsets: IndexSet) {
        for offset in offsets {
            let person = people[offset]
            modelContext.delete(person)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return PeopleView().modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
