//
//  Subuser.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/22/17.
//

import Foundation

/// The `Subuser` struct represents a subuser on a parent account.
public struct Subuser: Decodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The unique ID of the subuser account.
    public let id: Int
    
    /// The subuser's username.
    public let username: String
    
    /// The email address on the subuser's profile.
    public let email: String
    
    /// A boolean indicating if the subuser is disabled or not.
    public let disabled: Bool
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the struct with an ID, username, email, and "disabled" flag.
    ///
    /// - Parameters:
    ///   - id:         The unique ID of the subuser account.
    ///   - username:   The subuser's username.
    ///   - email:      The email address on the subuser's profile.
    ///   - disabled:   A boolean indicating if the subuser is disabled or not.
    public init(id: Int, username: String, email: String, disabled: Bool) {
        self.id = id
        self.username = username
        self.email = email
        self.disabled = disabled
    }
    
}
