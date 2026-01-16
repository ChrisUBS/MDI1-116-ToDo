//
//  DashboardView.swift
//  ToDo
//
//  Created by Christian Bonilla on 29/12/25.
//

import SwiftUI

struct DashboardView: View {
    @Binding var profile: Profile
    @State private var selectedGroup: TaskGroup?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var isShowingAddGroup = false
    @State private var isShowingSettings = false
    @State private var showPremiumAlert = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Text(profile.name)
                .font(.title)
                .accessibilityIdentifier("profileName")
            List(selection: $selectedGroup) {
                ForEach(profile.groups) { group in
                    NavigationLink(value: group) {
                        Label(group.title, systemImage: group.symbolName)
                    }
                }
                .onDelete(perform: deleteGroup)
            }
            .navigationTitle(profile.name)
            .listStyle(.sidebar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: languageManager.isRTL ? "chevron.right" : "chevron.left")
                            Text("Home")
                                .accessibilityIdentifier("homeButton")
                        }
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        if profile.groups.count >= 4 {
                            showPremiumAlert = true
                        } else {
                            isShowingAddGroup = true
                        }
                    } label: {
                        Image(systemName: "plus")
                            .accessibilityIdentifier("addGroupButton")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .accessibilityIdentifier("settingsButton")
                    }
                }
            }
            Spacer()
            HStack {
                Image("Flag")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(.circle)
                    .accessibilityIdentifier("flagSticker")
            }
        } detail: {
            if let group = selectedGroup {
                if let index = profile.groups.firstIndex(where: { $0.id == group.id}) {
                    TaskGroupDetailView(groups: $profile.groups[index])
                }
            } else {
                ContentUnavailableView("Select a Group", systemImage: "sidebar.left")
                    .accessibilityIdentifier("selectGroup")
            }
        }
        .sheet(isPresented: $isShowingAddGroup) {
            NewGroupView { newGroup in
                profile.groups.append(newGroup)
            }
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsView()
        }
        .alert("Premium Required", isPresented: $showPremiumAlert) {
            Button("Upgrade to Premium") {
                isShowingSettings = true
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Free users can create up to 4 groups. Upgrade to Premium to create unlimited groups.")
        }
    }
    
    func deleteGroup(at offsets: IndexSet) {
        profile.groups.remove(atOffsets: offsets)
    }
}
