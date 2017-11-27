//
//  Exception+Global.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/12/17.
//

import Foundation

public extension Exception {
    
    /// The `Exception.Global` struct contains global errors that can be thrown.
    public enum Global: Error, CustomStringConvertible {
        
        // MARK: - Cases
        //=========================================================================
        
        /// Thrown in the event an old, deprecated method is called.
        case methodUnavailable(AnyClass, String)
        
        /// Thrown if a `limit` property has an out-of-range value.
        case limitOutOfRange(Int, CountableClosedRange<Int>)
        
        
        
        
        // MARK: - Properties
        //=========================================================================
        
        /// A description for the error.
        public var description: String {
            switch self {
            case .methodUnavailable(let klass, let methodName):
                return "The `\(methodName)` method on \(klass) is no longer available."
            case .limitOutOfRange(let value, let range):
                return "The `limit` value must be between \(range.lowerBound) and \(range.upperBound) (inclusive). You specified \(value)."
            }
        }
        
    }
    
}
