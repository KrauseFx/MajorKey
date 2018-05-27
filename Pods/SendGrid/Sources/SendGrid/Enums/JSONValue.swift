//
//  JSONValue.swift
//  SendGrid
//
//  Created by Scott Kawai on 3/29/18.
//

import Foundation


/// The `JSONValue` enum is used to decode an API response that doesn't have an
/// explicit model in this library. Normally we would use something like
/// `[String : Any]`, but `Any` doesn't conform to `Codable`. Therefore, this
/// enum represents all the possible values found in JSON (and was heavily
/// inspired by the
/// [zoul/generic-json-swift](https://github.com/zoul/generic-json-swift/)
/// library)
///
/// - string: A string value
/// - int: An integer value.
/// - double: A double value.
/// - dictionary: An object/dictionary value.
/// - array: An array value.
/// - boolean: A boolean value.
/// - null: A null value.
public enum JSONValue: Codable {

    /// A string value.
    case string(String)

    /// An integer value.
    case int(Int)

    /// A double value.
    case double(Double)

    /// An object/dictionary value.
    case dictionary([String:JSONValue])

    /// An array value.
    case array([JSONValue])

    /// A boolean value.
    case boolean(Bool)

    /// A null value.
    case null

    /// The underlying value stored in the enum.
    public var rawValue: Codable? {
        switch self {
        case .string(let s):        return s
        case .int(let i):           return i
        case .double(let d):        return d
        case .dictionary(let hash): return hash
        case .array(let list):      return list
        case .boolean(let b):       return b
        case .null:                 return nil
        }
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let hash = try? container.decode([String: JSONValue].self) {
            self = .dictionary(hash)
        } else if let array = try? container.decode([JSONValue].self) {
            self = .array(array)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let b = try? container.decode(Bool.self) {
            self = .boolean(b)
        } else if let i = try? container.decode(Int.self) {
            self = .int(i)
        } else if let d = try? container.decode(Double.self) {
            self = .double(d)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid JSON value."))
        }
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let str):
            try container.encode(str)
        case .int(let i):
            try container.encode(i)
        case .double(let d):
            try container.encode(d)
        case .dictionary(let hash):
            try container.encode(hash)
        case .array(let list):
            try container.encode(list)
        case .boolean(let b):
            try container.encode(b)
        case .null:
            try container.encodeNil()
        }
    }
}

extension JSONValue: CustomStringConvertible {

    /// :nodoc:
    public var description: String {
        switch self.rawValue {
        case nil:
            return "<null>"
        case let desc as CustomStringConvertible:
            return desc.description
        default:
            return "\(self)"
        }
    }

}

