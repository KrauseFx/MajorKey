//
//  EmailEventRepresentable.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

/// The `EmailEventRepresentable` protocol is used by a struct or class that
/// represents an email event.
public protocol EmailEventRepresentable {
    
    /// The email address on the event
    var email: String { get }
    
    /// The date and time the event occurred on.
    var created: Date { get }
    
}
