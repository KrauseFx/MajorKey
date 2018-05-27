//
//  EncodingStrategy.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/14/17.
//

import Foundation

/// This struct houses both the date and data encoding strategies for a request.
public struct EncodingStrategy {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The encoding strategy for dates.
    public let dates: JSONEncoder.DateEncodingStrategy
    
    /// The encoding strategy for data.
    public let data: JSONEncoder.DataEncodingStrategy
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the struct with a date and data strategy.
    ///
    /// - Parameters:
    ///   - dates:  The date encoding strategy.
    ///   - data:   The data encoding strategy.
    public init(dates: JSONEncoder.DateEncodingStrategy = .secondsSince1970, data: JSONEncoder.DataEncodingStrategy = .base64) {
        self.dates = dates
        self.data = data
    }
    
}
