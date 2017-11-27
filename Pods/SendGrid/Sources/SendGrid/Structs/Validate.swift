//
//  Validate.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/8/17.
//

import Foundation


/// The `Validate` struct provides static methods for validating common
struct Validate {
    
    /// Takes a given input and regex pattern and returns a `Bool` indicating if
    /// there were any matches.
    ///
    /// - parameter input:      The `String` to search.
    /// - parameter pattern:    The regular expression pattern, expressed as a
    ///                         `String` to use.
    ///
    /// - returns: A `Bool` indicating if there were any matches.
    static func input(_ input: String, against pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            else { return false }
        let range = input.startIndex..<input.endIndex
        return regex.numberOfMatches(in: input, range: NSRange(range, in: input)) > 0
    }
    
}

extension Validate {
    
    /// Validates if a provided `String` is an email address.
    static func email(_ email: String) -> Bool {
        return self.input(email, against: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")
    }
    
    /// Validates text to be used in the subscription tracking setting.
    static func subscriptionTracking(body: String) -> Bool {
        return self.input(body, against: "<% .*%>")
    }
    
    /// Validates that a string does contain CLRF characters.
    static func noCLRF(in input: String) -> Bool {
        return self.input(input, against: "^([^;,\\s]+)$")
    }
    
}
