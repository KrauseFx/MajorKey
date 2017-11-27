//
//  Page.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

/// This struct is used to represent a page via the `limit` and `offset`
/// parameters found in various API calls.
public struct Page: Equatable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The limit value for each page of results.
    public let limit: Int
    
    /// The offset value for the page.
    public let offset: Int
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the struct with a limit and offset.
    ///
    /// - Parameters:
    ///   - limit:  The number of results per page.
    ///   - offset: The index to start the page on.
    public init(limit: Int, offset: Int) {
        self.limit = limit
        self.offset = offset
    }
    
}

/// :nodoc:
/// Equatable conformance.
public func ==(lhs: Page, rhs: Page) -> Bool {
    return lhs.limit == rhs.limit && lhs.offset == rhs.offset
}
