//
//  NewProfileView.swift
//  MDI1-116-ToDo
//
//  Created by Christian Bonilla on 15/01/26.
//

import SwiftUI

struct NewProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var languageManager: LanguageManager
    @State private var profileName = ""
    @State private var selectedIcon = "list.bullet"
    
//    let icons = ["list.bullet", "bookmark.fill", "graduationcap.fill", "cart.fill", "house.fill", "heart.fill"]
    let icons = ["Professor", "Student"]
    
    var onSave: (Profile) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Profile Name") {
                    TextField("Type the name of the new profile", text: $profileName)
                        .accessibilityIdentifier("groupNameTextField")
                }
                
                Section("Select Image") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                        ForEach(icons, id: \.self) { icon in
                            Image(icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .padding(6)
                                .background(selectedIcon == icon ? Color.cyan.opacity(0.2) : Color.gray.opacity(0.2))
                                .foregroundStyle(selectedIcon == icon ? Color.cyan : Color.gray)
                                .clipShape(.circle)
                                .onTapGesture {
                                    selectedIcon = icon
                                }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("New Profile Creator")
            .toolbar {
                if languageManager.isRTL {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") { saveProfile() }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                } else {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") { saveProfile() }
                    }
                }
            }
        }
    }
    
    func saveProfile() {
        let newProfile = Profile(name: profileName, profileImage: selectedIcon, groups: [])
        onSave(newProfile)
        dismiss()
    }
}
