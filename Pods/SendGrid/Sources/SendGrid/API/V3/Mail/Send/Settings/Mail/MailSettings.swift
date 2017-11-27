//
//  MailSettings.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/15/17.
//

import Foundation

/// The `MailSetting` struct houses any mail settings an email should be
/// configured with.
public struct MailSettings: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The BCC setting.
    public var bcc: BCCSetting?
    
    /// The bypass list management setting.
    public var bypassListManagement: BypassListManagement?
    
    /// The footer setting.
    public var footer: Footer?
    
    /// The sandbox mode setting.
    public var sandboxMode: SandboxMode?
    
    /// The spam checker setting.
    public var spamCheck: SpamChecker?
    
    /// A `Bool` indicating if at least one of the settings have been specified.
    public var hasSettings: Bool {
        return self.bcc != nil ||
            self.bypassListManagement != nil ||
            self.footer != nil ||
            self.sandboxMode != nil ||
            self.spamCheck != nil
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the struct with no settings set.
    public init() {}
    
}

/// Encodable conformance.
public extension MailSettings {
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        
        case bcc
        case bypassListManagement   = "bypass_list_management"
        case footer
        case sandboxMode            = "sandbox_mode"
        case spamCheck              = "spam_check"
        
    }
    
}

/// Validatable conformance.
extension MailSettings: Validatable {
    
    /// Bubbles up the validations for `bcc` and `spamCheck`.
    public func validate() throws {
        try self.bcc?.validate()
        try self.spamCheck?.validate()
    }
    
}
