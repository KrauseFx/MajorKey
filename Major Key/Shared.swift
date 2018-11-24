//
//  Shared.swift
//  Major Key
//
//  Created by Michael Schneider on 11/23/18.
//  Copyright © 2018 Felix Krause. All rights reserved.
//

import Foundation

struct Settings {
    static let senderEmailAddress = "Email Address"
    static let senderName = "New MajorKey"

    static let receiverName = "Name"

    static let defaultsForHistory = "MajorKeys"
    static let defaultsForEmail = "MajorKeyEmail"
}

// Extension to access shared settings between the app and the extensions
extension UserDefaults {

    // TODO: 'App Groups' capability needs to be enabled for the app
    static let shared = UserDefaults(suiteName: "group.me.majorkey.app")!

    // Access the shared user defaults
    var history: [String] {
        get {
            return UserDefaults.shared.stringArray(forKey: Settings.defaultsForHistory) ?? []
        }
        set(newHistory) {
            UserDefaults.shared.set(newHistory, forKey: Settings.defaultsForHistory)
        }
    }

    var emailAddress: String? {
        get {
            return UserDefaults.shared.string(forKey: Settings.defaultsForEmail)
        }
        set(newEmailAddress) {
            UserDefaults.shared.set(newEmailAddress, forKey: Settings.defaultsForEmail)
        }
    }
}
