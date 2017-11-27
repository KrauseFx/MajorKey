//
//  SandboxMode.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/15/17.
//

import Foundation

/// This allows you to send a test email to ensure that your request body is
/// valid and formatted correctly. For more information, please see the
/// [SendGrid docs](https://sendgrid.com/docs/Classroom/Send/v3_Mail_Send/sandbox_mode.html).
public struct SandboxMode: Encodable {
    
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
