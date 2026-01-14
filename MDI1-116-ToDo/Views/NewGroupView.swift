//
//  NewGroupView.swift
//  MDI1-114-ToDo
//
//  Created by Christian Bonilla on 11/12/25.
//

import SwiftUI

struct NewGroupView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var languageManager: LanguageManager
    @State private var groupName = ""
    @State private var selectedIcon = "list.bullet"
    
    let icons = ["list.bullet", "bookmark.fill", "graduationcap.fill", "cart.fill", "house.fill", "heart.fill"]
    
    var onSave: (TaskGroup) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Group Name") {
                    TextField("Insert the name of your group", text: $groupName)
                        .accessibilityIdentifier("groupNameTextField")
                }
                
                Section("Select Icon") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                        ForEach(icons, id: \.self) { icon in
                            Image(systemName: icon)
                            // Add UI design
                                .frame(width: 40, height: 40)
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
            .navigationTitle("New Group Creator")
            .toolbar {
                if languageManager.isRTL {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") { saveGroup() }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                } else {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") { saveGroup() }
                    }
                }
            }
        }
    }
    
    func saveGroup() {
        let newGroup = TaskGroup(title: groupName, symbolName: selectedIcon, tasks: [])
        onSave(newGroup)
        dismiss()
    }
}
