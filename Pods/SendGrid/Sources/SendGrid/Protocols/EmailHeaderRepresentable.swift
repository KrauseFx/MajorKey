//
//  EmailHeaderRepresentable.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/15/17.
//

import Foundation

/// The `EmailHeaderRepresentable` protocol provides a method for ensuring
/// custom headers are valid.
public protocol EmailHeaderRepresentable {
    
    /// A dictionary representing the headers that should be added to the email.
    var headers: [String : String]? { get set }
    
    /// Validates the `headers` property to ensure they are not using any
    /// reserved headers. If there is a problem, an error is thrown. If
    /// everything is fine, then this method returns nothing.
    ///
    /// - Throws:               If there is an invalid header, an error will be
    ///                         thrown.
    func validateHeaders() throws
}

public extension EmailHeaderRepresentable {
    
    /// The default implementation validates against the following headers:
    ///
    /// - X-SG-ID
    /// - X-SG-EID
    /// - Received
    /// - DKIM-Signature
    /// - Content-Type
    /// - Content-Transfer-Encoding
    /// - To
    /// - From
    /// - Subject
    /// - Reply-To
    /// - CC
    /// - BCC
    public func validateHeaders() throws {
        guard let head = self.headers else { return }
        let reserved: [String] = [
            "x-sg-id",
            "x-sg-eid",
            "received",
            "dkim-signature",
            "content-type",
            "content-transfer-encoding",
            "to",
            "from",
            "subject",
            "reply-to",
            "cc",
            "bcc"
        ]
        for (key, _) in head {
            guard reserved.index(of: key.lowercased()) == nil else { throw Exception.Mail.headerNotAllowed(key) }
            let regex = try NSRegularExpression(pattern: "(\\s)", options: [.caseInsensitive, .anchorsMatchLines])
            guard regex.numberOfMatches(in: key, options: [], range: NSMakeRange(0, key.count)) == 0 else {
                throw Exception.Mail.malformedHeader(key)
            }
        }
    }
}
