//
//  InvalidEmail.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

/// The `InvalidEmail` struct represents an entry on the "Invalid Email"
/// suppression list.
public struct InvalidEmail: EmailEventRepresentable, Decodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The email address on the event.
    public let email: String
    
    /// The date and time the event occurred on.
    public let created: Date
    
    /// The description of why the email was classified as invalid.
    public let reason: String
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the event with all the required properties.
    ///
    /// - Parameters:
    ///   - email:      The email address on the event.
    ///   - created:    The date and time the event occurred on.
    ///   - reason:     The description of why the email was classified as
    ///                 invalid.
    public init(email: String, created: Date, reason: String) {
        self.email = email
        self.created = created
        self.reason = reason
    }
    
}
