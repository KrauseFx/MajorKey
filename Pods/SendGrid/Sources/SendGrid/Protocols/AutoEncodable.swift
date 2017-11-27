//
//  AutoEncodable.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/17/17.
//

import Foundation

/// The `AutoEncodable` protocol adds to the `Encodable` protocol to provide
/// a quick way to retrieve the encoded representation of the object.
public protocol AutoEncodable: Encodable {
    
    /// The date and date encoding strategy.
    var encodingStrategy: EncodingStrategy { get }
    
    /// The encoded data representation.
    func encode(formatting: JSONEncoder.OutputFormatting) -> Data?
    
    /// The encoded string representation.
    func encodedString(formatting: JSONEncoder.OutputFormatting) -> String?
    
}

public extension AutoEncodable {
    
    /// The default implementation uses `JSONEncoder` to encode the object.
    func encode(formatting: JSONEncoder.OutputFormatting = []) -> Data? {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = self.encodingStrategy.data
        encoder.dateEncodingStrategy = self.encodingStrategy.dates
        encoder.outputFormatting = formatting
        return try? encoder.encode(self)
    }
    
    /// The default implementation uses `JSONEncoder` to encode the object.
    func encodedString(formatting: JSONEncoder.OutputFormatting = []) -> String? {
        guard let d = self.encode(formatting: formatting) else { return nil }
        return String(data: d, encoding: .utf8)
    }
    
}
