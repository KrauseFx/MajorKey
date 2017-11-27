//
//  BCCSetting.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/16/17.
//

import Foundation


/// This allows you to have a blind carbon copy automatically sent to the
/// specified email address for every email that is sent.
public struct BCCSetting: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// A bool indicating if the setting should be toggled on or off.
    public let enable: Bool
    
    /// The email address that you would like to receive the BCC.
    public let email: String?

    
    // MARK: - Initialization
    //=========================================================================

    /// Initializes the setting with an email to use as the BCC address. This
    /// setting can also be used to turn off the BCC app if it is normally on by
    /// default on your SendGrid account. To turn off the setting for this
    /// specific email, pass in `nil` as the email address (`nil` is the default
    /// value as well, so if you want to turn off the setting you can initialize
    /// the setting with no parameters, i.e. `BCCSetting()`).
    ///
    /// - Parameters:
    ///   - email:  A `String` representing the email address to set as the BCC.
    public init(email: String? = nil) {
        self.email = email
        self.enable = email != nil
    }

    /// Initializes the setting with an email to use as the BCC address.
    ///
    /// - Parameters:
    ///   - email:  An `Address` instance to set as the BCC.
    public init(address: Address) {
        self.init(email: address.email)
    }
    
}


/// Validatable conformance
extension BCCSetting: Validatable {
    
    /// Validates that the BCC email is a valid email address.
    public func validate() throws {
        if let em = self.email {
            guard Validate.email(em) else {
                throw Exception.Mail.malformedEmailAddress(em)
            }
        }
    }

}
