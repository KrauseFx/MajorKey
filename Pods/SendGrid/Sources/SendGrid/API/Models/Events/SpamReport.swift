//
//  SpamReport.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation


/// The `SpamReport` struct represents a spam report event.
public struct SpamReport: EmailEventRepresentable, Decodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The email address on the event.
    public let email: String
    
    /// The date and time the event occurred on.
    public let created: Date
    
    /// The IP address of the user when they marked the email as spam.
    public let ip: String
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the event with all the required properties.
    ///
    /// - Parameters:
    ///   - email:      The email address on the event.
    ///   - created:    The date and time the event occurred on.
    ///   - ip:         The IP address of the user when they marked the email as
    ///                 spam.
    public init(email: String, created: Date, ip: String) {
        self.email = email
        self.created = created
        self.ip = ip
    }
}
