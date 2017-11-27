//
//  GlobalUnsubscribe.Add.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

public extension GlobalUnsubscribe {
    
    /// The `GlobalUnsubscribe.Add` class represents the API call to add email
    /// addresses to the global unsubscribe list.
    ///
    /// You can specify email addresses (as strings), or you can use `Address` 
    /// instances.
    /// 
    /// ```swift
    /// do {
    ///     let request = GlobalUnsubscribe.Add(emails: "foo@example.none", "bar@example.none")
    ///     try Session.shared.send(request: request) { (response) in 
    ///         print(response?.httpUrlResponse?.statusCode)
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    public class Add: Request<[String:Any]>, AutoEncodable {
        
        // MARK: - Properties
        //=========================================================================
        
        /// The email addresses to add to the global unsubscribe list.
        public let emails: [String]
        
        
        // MARK: - Initialization
        //=========================================================================
        
        /// Initializes the request with a list of email addresses to add to the
        /// global unsubscribe list.
        ///
        /// - Parameter emails: An array of email addresses to add to the global
        ///                     unsubscribe list.
        public init(emails: [String]) {
            self.emails = emails
            super.init(
                method: .POST,
                contentType: .json,
                path: "/v3/asm/suppressions/global"
            )
        }
        
        /// Initializes the request with a list of email addresses to add to the
        /// global unsubscribe list.
        ///
        /// - Parameter emails: An array of email addresses to add to the global
        ///                     unsubscribe list.
        public convenience init(emails: String...) {
            self.init(emails: emails)
        }
        
        /// Initializes the request with a list of addresses to add to the
        /// global unsubscribe list.
        ///
        /// - Parameter emails: An array of addresses to add to the global
        ///                     unsubscribe list.
        public convenience init(addresses: [Address]) {
            let emails = addresses.map { $0.email }
            self.init(emails: emails)
        }
        
        /// Initializes the request with a list of addresses to add to the
        /// global unsubscribe list.
        ///
        /// - Parameter emails: An array of addresses to add to the global
        ///                     unsubscribe list.
        public convenience init(addresses: Address...) {
            self.init(addresses: addresses)
        }
        
    }
    
}

/// Encodable conformance.
public extension GlobalUnsubscribe.Add {
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case emails = "recipient_emails"
    }
    
}
