//
//  LanguageManager.swift
//  ToDo
//
//  Created by Christian Bonilla on 18/12/25.
//

import SwiftUI
import Combine

final class LanguageManager: ObservableObject {
    @AppStorage("appLanguage") var languageCode: String = Locale.current.identifier

    init() {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("-resetLanguage") {
            UserDefaults.standard.removeObject(forKey: "appLanguage")
            languageCode = Locale.current.identifier
        }
    }
    
    var isRTL: Bool {
        Locale.characterDirection(forLanguage: languageCode) == .rightToLeft
    }

    var locale: Locale {
        Locale(identifier: languageCode)
    }
}
