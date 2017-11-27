//
//  DecodingStrategy.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/14/17.
//

import Foundation

/// This struct houses both the date and data decoding strategies for a
/// response.
public struct DecodingStrategy {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The encoding strategy for dates.
    public let dates: JSONDecoder.DateDecodingStrategy
    
    /// The encoding strategy for data.
    public let data: JSONDecoder.DataDecodingStrategy
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the struct with a date and data strategy.
    ///
    /// - Parameters:
    ///   - dates:  The date encoding strategy.
    ///   - data:   The data encoding strategy.
    public init(dates: JSONDecoder.DateDecodingStrategy = .secondsSince1970, data: JSONDecoder.DataDecodingStrategy = .base64) {
        self.dates = dates
        self.data = data
    }
    
}

#if os(Linux)
    /// :nodoc:
    /// For some reason, on macOS we have
    /// `JSONDecoder.DataDecodingStrategy.base64` and on Linux we have
    /// `JSONDecoder.DataDecodingStrategy.base64Decode`, so this extension is to
    /// add a `.base64` option for Linux.
    ///
    /// This issue was fixed in https://github.com/apple/swift-corelibs-foundation/pull/1219,
    /// however it didn't make the 4.0 release.
    extension JSONDecoder.DataDecodingStrategy {
        public static let base64 = JSONDecoder.DataDecodingStrategy.base64Decode
    }
#endif
