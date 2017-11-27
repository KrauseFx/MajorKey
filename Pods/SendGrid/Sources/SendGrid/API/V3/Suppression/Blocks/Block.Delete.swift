//
//  Block.Delete.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension Block {

    /// The `Block.Delete` class represents the API call to [delete from the
    /// block list](https://sendgrid.com/docs/API_Reference/Web_API_v3/blocks.html#Delete-blocks-DELETE).
    /// You can use it to delete the entire list, or specific entries in the 
    /// list.
    /// 
    /// ## Delete All Blocks
    /// 
    /// To delete all blocks, use the request returned from `Block.Delete.all`.  
    /// This request will delete all blocks on your block list.
    /// 
    /// ```swift
    /// do {
    ///     let request = Block.Delete.all
    ///     try Session.shared.send(request: request) { (response) in
    ///         print(response?.httpUrlResponse?.statusCode)
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    /// 
    /// ## Delete Specific Blocks
    /// 
    /// To delete specific entries from your block list, use the `Block.Delete` 
    /// class. You can either specify email addresses (as strings), or you can 
    /// use `Block` instances (useful for if you just retrieved some from the 
    /// `Block.Get` class).
    /// 
    /// ```swift
    /// do {
    ///     let request = Block.Delete(emails: "foo@example.none", "bar@example.none")
    ///     try Session.shared.send(request: request) { (response) in
    ///         print(response?.httpUrlResponse?.statusCode)
    ///     }
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    public class Delete: SuppressionListDeleter<Block>, AutoEncodable {
        
        // MARK: - Properties
        //======================================================================
        
        /// The path for the blocks API
        override var path: String { return "/v3/suppression/blocks" }
        
        /// Returns a request that will delete *all* the entries on your block
        /// list.
        public static var all: Block.Delete {
            return Block.Delete(deleteAll: true, emails: nil)
        }
        
    }
    
}

/// Encodable conformance
public extension Block.Delete {
    
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
