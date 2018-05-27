//
//  InvalidEmail.Delete.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension InvalidEmail {

    /// The `InvalidEmail.Delete` class represents the API call to [delete from
    /// the invalid email list](https://sendgrid.com/docs/API_Reference/Web_API_v3/invalid_emails.html#Delete-invalid-emails-DELETE).
    /// You can use it to delete the entire list, or specific entries on the 
    /// list.
    ///
    /// ## Delete All Invalid Emails
    /// 
    /// To delete all invalid emails, use the request returned from 
    /// `InvalidEmail.Delete.all`.  This request will delete all addresses on 
    /// your invalid email list.
    /// 
    /// ```swift
    /// do {
    ///     let request = InvalidEmail.Delete.all
    ///     try Session.shared.send(request: request) { (response) in
    ///         print(response?.httpUrlResponse?.statusCode)
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    /// 
    /// ## Delete Specific Invalid Emails
    /// 
    /// To delete specific entries from your invalid email list, use the 
    /// `InvalidEmail.Delete` class. You can either specify email addresses (as 
    /// strings), or you can use `InvalidEmail` instances (useful for if you 
    /// just retrieved some from the `InvalidEmail.Get` class).
    /// 
    /// ```swift
    /// do {
    ///     let request = InvalidEmail.Delete(emails: "foo@example", "bar@example")
    ///     try Session.shared.send(request: request) { (response) in
    ///         print(response?.httpUrlResponse?.statusCode)
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    public class Delete: SuppressionListDeleter<InvalidEmail>, AutoEncodable {
        
        // MARK: - Properties
        //======================================================================
        
        /// Returns a request that will delete *all* the entries on your spam
        /// report list.
        public static var all: InvalidEmail.Delete {
            return InvalidEmail.Delete(deleteAll: true, emails: nil)
        }
        
        
        // MARK: - Initialization
        //=========================================================================
        
        /// Private initializer to set all the required properties.
        ///
        /// - Parameters:
        ///   - path:       The path for the request's API endpoint.
        ///   - deleteAll:  A `Bool` indicating if all the events on the suppression
        ///                 list should be deleted.
        ///   - emails:     An array of emails to delete from the suppression list.
        override init(path: String? = nil, deleteAll: Bool?, emails: [String]?) {
            super.init(path: "/v3/suppression/invalid_emails", deleteAll: deleteAll, emails: emails)
        }
        
    }
    
}

/// Encodable conformance
public extension InvalidEmail.Delete {
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case deleteAll  = "delete_all"
        case emails
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.deleteAll, forKey: .deleteAll)
        try container.encodeIfPresent(self.emails, forKey: .emails)
    }
    
}
