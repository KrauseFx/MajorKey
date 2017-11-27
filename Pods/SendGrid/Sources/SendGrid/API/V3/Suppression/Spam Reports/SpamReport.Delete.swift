//
//  SpamReport.Delete.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension SpamReport {

    /// The `SpamReport.Delete` class represents the API call to [delete from
    /// the spam report list](https://sendgrid.com/docs/API_Reference/Web_API_v3/spam_reports.html#Delete-a-specific-spam-report-DELETE).
    /// You can use it to delete the entire list, or specific entries from the 
    /// list.
    ///
    /// ## Delete All Spam Reports
    /// 
    /// To delete all spam reports, use the request returned from 
    /// `SpamReport.Delete.all`.  This request will delete all spam reports on 
    /// your spam report list.
    /// 
    /// ```swift
    /// do {
    ///     let request = SpamReport.Delete.all
    ///     try Session.shared.send(request: request) { (response) in
    ///         print(response?.httpUrlResponse?.statusCode)
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    /// 
    /// ## Delete Specific Spam Reports
    /// 
    /// To delete specific entries from your spam report list, use the 
    /// `SpamReport.Delete` class. You can either specify email addresses (as 
    /// strings), or you can use `SpamReport` instances (useful for if you just 
    /// retrieved some from the `SpamReport.Get` class).
    /// 
    /// ```swift
    /// do {
    ///     let request = SpamReport.Delete(emails: "foo@example.none", "bar@example.none")
    ///     try Session.shared.send(request: request) { (response) in
    ///         print(response?.httpUrlResponse?.statusCode)
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    public class Delete: SuppressionListDeleter<SpamReport>, AutoEncodable {
        
        // MARK: - Properties
        //======================================================================
        
        /// The path for the spam report API
        override var path: String { return "/v3/suppression/spam_reports" }
        
        /// Returns a request that will delete *all* the entries on your spam
        /// report list.
        public static var all: SpamReport.Delete {
            return SpamReport.Delete(deleteAll: true, emails: nil)
        }
        
    }
    
}

/// Encodable conformance
public extension SpamReport.Delete {
    
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
