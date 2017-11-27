//
//  Content.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/13/17.
//

import Foundation

/// The `Content` class represents a MIME part of the email message (i.e. the plain text and HTML parts of an email).
public struct Content: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The content type of the content.
    public let type: ContentType
    
    /// The value of the content.
    public let value: String
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the content with a content type and value.
    ///
    /// - Parameters:
    ///   - contentType:    The content type.
    ///   - aValue:         The value of the content.
    public init(contentType: ContentType, value aValue: String) {
        self.type = contentType
        self.value = aValue
    }
    
}

/// Validatable conformance.
extension Content: Validatable {
    
    /// Validates the content.
    public func validate() throws {
        guard self.value.count > 0 else {
            throw Exception.Mail.contentHasEmptyString
        }
        try self.type.validate()
    }
    
}

/// Convenience class initializers.
extension Content {
    
    /// Creates a new `Content` instance used to represent a plain text body.
    ///
    /// - Parameter value:  The plain text value of the body.
    /// - Returns:          A `Content` instance with the "text/plain" content
    ///                     type.
    public static func plainText(body value: String) -> Content {
        return Content(contentType: .plainText, value: value)
    }
    
    /// Creates a new `Content` instance used to represent an HTML body.
    ///
    /// - Parameter value:  The HTML text value of the body.
    /// - Returns:          A `Content` instance with the "text/html" content
    ///                     type.
    public static func html(body value: String) -> Content {
        return Content(contentType: .htmlText, value: value)
    }
    
    /// Return an array containing a plain text and html body.
    ///
    /// - Parameters:
    ///   - plain:  The text value for the plain text body.
    ///   - html:   The HTML text value for the HTML body.
    /// - Returns:  An array of `Content` instances.
    public static func emailBody(plain: String, html: String) -> [Content] {
        return [
            Content.plainText(body: plain),
            Content.html(body: html)
        ]
    }
    
}
