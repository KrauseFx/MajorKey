//
//  GlobalUnsubscribe.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

/// The `GlobalUnsubscribe` struct represents an entry on the "Global
/// Unsubscribe" suppression list.
public struct GlobalUnsubscribe: EmailEventRepresentable, Decodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The email address on the event.
    public let email: String
    
    /// The date and time the event occurred on.
    public let created: Date
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the event with all the required properties.
    ///
    /// - Parameters:
    ///   - email:      The email address on the event.
    ///   - created:    The date and time the event occurred on.
    public init(email: String, created: Date) {
        self.email = email
        self.created = created
    }
    
}
