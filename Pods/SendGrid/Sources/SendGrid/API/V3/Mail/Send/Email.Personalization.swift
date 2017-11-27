//
//  Personalization.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/15/17.
//

import Foundation

/// The `Personalization` struct is used by the `Email` class to add
/// personalization settings to an email. The only required property is the `to`
/// property, and each email must have at least one personalization.
open class Personalization: Encodable, EmailHeaderRepresentable, Scheduling {
    
    // MARK: - Properties
    //=========================================================================
    
    /// An array of recipients to send the email to.
    open let to: [Address]
    
    /// An array of recipients to add as a CC on the email.
    open var cc: [Address]?
    
    /// An array of recipients to add as a BCC on the email.
    open var bcc: [Address]?
    
    /// A personalized subject for the email.
    open var subject: String?
    
    /// An optional set of headers to add to the email in this personalization.
    /// Each key in the dictionary should represent the name of the header, and
    /// the values of the dictionary should be equal to the values of the
    /// headers.
    open var headers: [String:String]?
    
    /// An optional set of substitutions to replace in this personalization. The
    /// keys in the dictionary should represent the substitution tags that
    /// should be replaced, and the values should be the replacement values.
    open var substitutions: [String:String]?
    
    /// A set of custom arguments to add to the email. The keys of the
    /// dictionary should be the names of the custom arguments, while the values
    /// should represent the value of each custom argument.
    open var customArguments: [String:String]?
    
    /// An optional time to send the email at.
    open var sendAt: Date? = nil
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the email with all the available properties.
    ///
    /// - Parameters:
    ///   - to:                 An array of addresses to send the email to.
    ///   - cc:                 An array of addresses to add as CC.
    ///   - bcc:                An array of addresses to add as BCC.
    ///   - subject:            A subject to use in the personalization.
    ///   - headers:            A set of additional headers to add for this
    ///                         personalization. The keys and values in the
    ///                         dictionary should represent the name of the
    ///                         headers and their values, respectively.
    ///   - substitutions:      A set of substitutions to make in this
    ///                         personalization. The keys and values in the
    ///                         dictionary should represent the substitution
    ///                         tags and their replacement values, respectively.
    ///   - customArguments:    A set of custom arguments to add to the
    ///                         personalization. The keys and values in the
    ///                         dictionary should represent the argument names
    ///                         and values, respectively.
    ///   - sendAt:             A time to send the email at.
    public init(to: [Address], cc: [Address]? = nil, bcc: [Address]? = nil, subject: String? = nil, headers: [String:String]? = nil, substitutions: [String:String]? = nil, customArguments: [String:String]? = nil, sendAt: Date? = nil) {
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.subject = subject
        self.headers = headers
        self.substitutions = substitutions
        self.customArguments = customArguments
        self.sendAt = sendAt
    }
    
    
    /// Initializes the personalization with a set of email addresses.
    ///
    /// - Parameter recipients: A list of email addresses to use as the "to"
    ///                         addresses.
    public convenience init(recipients: String...) {
        let list: [Address] = recipients.map { Address(email: $0) }
        self.init(to: list)
    }
    
}

/// Encodable conformance.
public extension Personalization {
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case to
        case cc
        case bcc
        case subject
        case headers
        case substitutions
        case customArguments = "custom_args"
        case sendAt = "send_at"
    }
    
}

/// Validatable conformance.
extension Personalization: Validatable {
    
    /// Validates that the personalization has recipients and that they are
    /// proper email addresses as well as making sure the sendAt date is valid.
    open func validate() throws {
        guard self.to.count > 0 else { throw Exception.Mail.missingRecipients }
        try self.validateHeaders()
        try self.validateSendAt()
        try self.to.forEach { try $0.validate() }
        try self.cc?.forEach { try $0.validate() }
        try self.bcc?.forEach { try $0.validate() }
        
        if let s = self.subject {
            guard s.count > 0 else { throw Exception.Mail.missingSubject }
        }
        
        if let sub = self.substitutions {
            guard sub.count <= Constants.SubstitutionLimit else { throw Exception.Mail.tooManySubstitutions }
        }
    }
    
}
