//
//  BypassListManagement.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/16/17.
//

import Foundation

/// The `BypassListManagement` class allows you to bypass all unsubscribe groups
/// and suppressions to ensure that the email is attempted to be delivered to
/// every single recipient. This should only be used in emergencies when it is
/// absolutely necessary that every recipient receives your email. Ex: outage
/// emails, or forgot password emails.
public struct BypassListManagement: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// A bool indicating if the setting should be toggled on or off.
    public let enable: Bool
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the setting with a flag indicating if its enabled or not.
    ///
    /// - Parameter enable: A bool indicating if the setting should be toggle on
    ///                     or off (default is `true`).
    public init(enable: Bool = true) {
        self.enable = enable
    }
    
}
