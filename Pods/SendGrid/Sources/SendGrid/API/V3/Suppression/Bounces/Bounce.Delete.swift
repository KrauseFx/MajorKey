//
//  Bounce.Delete.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension Bounce {

    /// The `Bounce.Delete` class represents the API call to [delete from the
    /// bounce list](https://sendgrid.com/docs/API_Reference/Web_API_v3/bounces.html#Delete-bounces-DELETE).
    /// You can use it to delete the entire list, or specific entries from the 
    /// list.
    ///
    /// ## Delete All Bounces
    /// 
    /// To delete all bounces, use the request returned from 
    /// `Bounce.Delete.all`.  This request will delete all bounces on your 
    /// bounce list.
    /// 
    /// ```swift
    /// do {
    ///     let request = Bounce.Delete.all
    ///     try Session.shared.send(request: request) { (response) in
    ///         print(response?.httpUrlResponse?.statusCode)
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    /// 
    /// ## Delete Specific Bounces
    /// 
    /// To delete specific entries from your bounce list, use the 
    /// `Bounce.Delete` class. You can either specify email addresses (as 
    /// strings), or you can use `Bounce` instances (useful for if you just 
    /// retrieved some from the [Get Bounces](#get-all-bounces) call above).
    /// 
    /// ```swift
    /// do {
    ///     let request = Bounce.Delete(emails: "foo@example.none", "bar@example.none")
    ///     try Session.shared.send(request: request) { (response) in
    ///         print(response?.httpUrlResponse?.statusCode)
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    public class Delete: SuppressionListDeleter<Bounce>, AutoEncodable {
        
        // MARK: - Properties
        //======================================================================
        
        /// The path for the bounces API
        override var path: String { return "/v3/suppression/bounces" }
        
        /// Returns a request that will delete *all* the entries on your bounce
        /// list.
        public static var all: Bounce.Delete {
            return Bounce.Delete(deleteAll: true, emails: nil)
        }
        
    }
    
}

/// Encodable conformance
public extension Bounce.Delete {
    
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
