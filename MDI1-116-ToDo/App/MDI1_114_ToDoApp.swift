//
//  MDI1_114_ToDoApp.swift
//  MDI1-114-ToDo
//
//  Created by Christian Bonilla on 09/12/25.
//

import SwiftUI

@main
struct MDI1_114_ToDoApp: App {
    @StateObject private var languageManager = LanguageManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(languageManager)
                .environment(\.locale, languageManager.locale)
                .environment(\.layoutDirection, languageManager.isRTL ? .rightToLeft : .leftToRight)
        }
    }
}
