//
//  EditPersonView.swift
//  FaceFacts
// 
//  Created by Brad Siegel on 2/27/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditPersonView: View {
    @Environment(\.modelContext) var modelContext
    // Use Binable to create a binding from an Observable object (@Model conforms
    // to Observable
    @Bindable var person: Person
    @Binding var navigationPath: NavigationPath
    @State private var selectedItem: PhotosPickerItem?
    
    @Query(sort: [
        SortDescriptor(\Event.name),
        SortDescriptor(\Event.location)
    ]) var events: [Event]
    
    var body: some View {
        Section {
            if let imageData = person.photo,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Select a photo", systemImage: "person")
            }
        }
        
        Form {
            Section {
                TextField("Name", text: $person.name)
                    .textContentType(.name)
                
                TextField("Email address", text: $person.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            
            Section("Where did you meet them?") {
                Picker("Met at", selection: $person.metAt) {
                    Text("Unknown event")
                        .tag(Optional<Event>.none)
                    
                    if events.isEmpty == false {
                        Divider()
                        
                        ForEach(events) { event in
                            Text(event.name)
                                .tag(Optional(event)) // person.metAt is opitional so SwiftData requires this to be an optional even though there is a value
                        }
                    }
                }
                Button("Add a new event", action: addEvent)
            }
            
            Section("Notes") {
                TextField("Details about this person", text: $person.details, axis: .vertical)
            }
        }
        .navigationTitle("Edit Person")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Event.self) { event in
            EditEventView(event: event)
        }
        .onChange(of: selectedItem, loadPhoto)
    }
    
    func addEvent() {
        let event = Event(name: "", location: "")
        modelContext.insert(event)
        navigationPath.append(event) // navigate right to edit event screen
    }
    
    func loadPhoto() {
        Task { @MainActor in // Triggers a UI reload so needs to be on main thread hence @MainActor
            person.photo = try await selectedItem?.loadTransferable(type: Data.self)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return EditPersonView(
            person: previewer.person,
            navigationPath: .constant(NavigationPath())
        ).modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}






