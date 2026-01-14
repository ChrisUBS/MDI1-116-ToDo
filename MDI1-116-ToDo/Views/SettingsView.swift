//
//  SettingsView.swift
//  ToDo
//
//  Created by Christian Bonilla on 18/12/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) private var dismiss
    @State private var isPremium = false

    let languages = [
//        ("System", nil),
        ("English", "en"),
        ("Français", "fr"),
        ("Español (LatAm)", "es-419"),
        ("Arabic (العربية)", "ar")
    ]

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Appearance
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .accessibilityIdentifier("darkModeToggle")
                }

                // MARK: - Language
                Section("Language") {
                    Picker("App Language", selection: $languageManager.languageCode) {
                        ForEach(languages, id: \.1) { name, code in
                            Text(name).tag(code)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .accessibilityIdentifier("languagePicker")
                }
                
                // MARK: - Premium
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Go Premium")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 6) {
                            Label("Unlimited profile creation", systemImage: "person.crop.circle.badge.plus")
                            Label("Unlimited group creation", systemImage: "person.3.fill")
                            Label("Ad-free experience", systemImage: "nosign")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                        Button {
                            isPremium.toggle()
                        } label: {
                            Text(isPremium ? "You're Premium" : "Upgrade to Premium")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(isPremium ? .green : .blue)
                        .padding(.top, 8)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
