//
//  ContentView.swift
//  MDI1-114-ToDo
//
//  Created by Christian Bonilla on 09/12/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var taskGroups: [TaskGroup] = []
    @State private var profiles: [Profile] = []
    @State private var path = NavigationPath()
    @State private var isShowingAddProfile = false
    @State private var isShowingSettings = false
    @State private var showPremiumAlert = false
    @Environment(\.scenePhase) private var scenePhase
    
    let saveKey = "savedProfiles"
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    Text("Select the working profile")
                        .font(.largeTitle.bold())
                        .accessibilityIdentifier("selectProfileTitle")
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach($profiles) { $profile in
                            NavigationLink(value: profile) {
                                VStack {
                                    Image(profile.profileImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .clipShape(.circle)

                                    Text(profile.name)
                                        .font(.title2.bold())
                                }
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    deleteProfile(profile)
                                } label: {
                                    Label("Delete Profile", systemImage: "trash")
                                }
                            }
                            .accessibilityIdentifier("profileCard_\(profile.name)")
                        }
                    }
                }
            }
            .navigationTitle("ToDo App")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Profile.self) { selectedProfile in
                if let index = profiles.firstIndex(where: { $0.id == selectedProfile.id }) {
                    DashboardView(profile: $profiles[index])
                        .navigationBarBackButtonHidden(true)
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        if profiles.count >= 3 {
                            showPremiumAlert = true
                        } else {
                            isShowingAddProfile = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add New Profile")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingAddProfile) {
            NewProfileView { newProfile in
                profiles.append(newProfile)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear{
            loadData()
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .active {
                print("App is active and running")
            } else if newValue == .inactive {
                print("App is inactive / not used right now")
            } else if newValue == .background {
                print("App is in background mode")
                saveData()
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
            Text("Free users can create up to 2 profiles. Upgrade to Premium to create unlimited profiles.")
        }
    }
    
    func saveData() {
        if let encodeData = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encodeData, forKey: saveKey)
        }
    }
    
    func loadData() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey) {
            if let decodedProfile = try? JSONDecoder().decode([Profile].self, from: savedData) {
                profiles = decodedProfile
                return
            }
        }
        // Show mock data for dev purposes
//        profiles = Profile.sample
    }
    
    func deleteProfile(_ profile: Profile) {
        profiles.removeAll { $0.id == profile.id }
        saveData()
    }
}
