//
//  HTTPMethod.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/8/17.
//
import Foundation

/// The `HTTPMethod` enum represents the various verbs used in an HTTP request.
public enum HTTPMethod: String, CustomStringConvertible {
    
    // MARK: - Cases
    //=========================================================================
    /// Represents a "GET" call.
    case GET
    
    /// Represents a "POST" call.
    case POST
    
    /// Represents a "PUT" call.
    case PUT
    
    /// Represents a "PATCH" call.
    case PATCH
    
    /// Represents a "DELETE" call.
    case DELETE
    
    // MARK: - Properties
    //=========================================================================
    /// The String representation of the HTTP method.
    public var description: String { return self.rawValue }
    
    /// A bool indicating if the HTTP method contains an HTTP body in its
    /// request.
    public var hasBody: Bool {
        switch self {
        case .GET:  return false
        default:    return true
        }
    }
}
