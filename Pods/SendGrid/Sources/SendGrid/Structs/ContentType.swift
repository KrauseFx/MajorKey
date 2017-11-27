//
//  ContentType.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/8/17.
//

import Foundation

/// The `ContentType` struct represents the common types of Content Types used
/// when sending through the SendGrid API.
public struct ContentType: CustomStringConvertible, Equatable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The first part of the content type, for example `text` in `text/html`.
    public let type: String
    
    /// The second part of the content type, for example `html` in `text/html`.
    public let subtype: String
    
    /// The full value of the content type.
    public var description: String {
        return "\(self.type)/\(self.subtype)"
    }
    
    /// The `index` property is an internal property used to sort in priority
    /// the content type. The main use for this is to ensure conformance with
    /// [RFC 1341, Section 7.2.3](https://tools.ietf.org/html/rfc1341), which
    /// states that the various parts of an email body should be ordered in
    /// increasing order of preference. Sorting off of this property will ensure
    /// that the HTML content is given preference over the plain content.
    internal var index: Int {
        switch (self.type, self.subtype) {
        case ("text", "plain"): return 0
        case ("text", "html"):  return 1
        default:                return 2
        }
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the struct with a type and subtype. These two parameters
    /// will be combined with a `/` between to create the value of the
    /// Content-Type header.
    ///
    /// - parameter type:       The first part of the content type, for example
    ///                         `text` in `text/html`.
    /// - parameter subtype:    The second part of the content type, for example
    ///                         `html` in `text/html`.
    public init(type: String, subtype: String) {
        self.type = type.lowercased()
        self.subtype = subtype.lowercased()
    }
    
    /// Initializes the struct with a raw value. The raw value should be a
    /// string containing a type and subtype separated by a `/` character, such
    /// as "text/html".  If the provided value is invalid, `nil` is returned.
    ///
    /// - parameter rawValue:   A `String` representing the value of the content
    ///                         type.
    public init?(rawValue: String) {
        let split = rawValue.components(separatedBy: "/")
        guard split.count == 2,
            let type = split.first?.lowercased(),
            let subtype = split.last?.lowercased()
            else { return nil }
        self.init(type: type, subtype: subtype)
    }
}

/// :nodoc:
/// Equatable conformance.
public func ==(lhs: ContentType, rhs: ContentType) -> Bool {
    return lhs.type == rhs.type && lhs.subtype == rhs.subtype
}

/// Validatable conformance.
extension ContentType: Validatable {
    
    /// Validates that the content-type has no CLRF characters.
    public func validate() throws {
        guard self.description.count > 2, Validate.noCLRF(in: self.description) else {
            throw Exception.ContentType.invalidContentType(self.description)
        }
    }
    
}

/// Encodable conformance.
extension ContentType: Encodable {
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
    
}

/// Predefined content types.
public extension ContentType {
    
    /// Represents "application/x-www-form-urlencoded" encodings.
    static let formUrlEncoded = ContentType(type: "application", subtype: "x-www-form-urlencoded")
    
    /// The "application/json" content type.
    static let json = ContentType(type: "application", subtype: "json")
    
    /// The "text/plain" content type, used for the plain text portion of an email.
    static let plainText = ContentType(type: "text", subtype: "plain")
    
    /// The "text/html" content type, used for the HTML portion of an email.
    static let htmlText = ContentType(type: "text", subtype: "html")
    
    /// The "application/csv" content type, used for CSV attachments.
    static let csv = ContentType(type: "application", subtype: "csv")
    
    /// The "application/pdf" content type, used for PDF attachments.
    static let pdf = ContentType(type: "application", subtype: "pdf")
    
    /// The "application/zip" content type, used for Zip file attachments.
    static let zip = ContentType(type: "application", subtype: "zip")
    
    /// The "image/png" content type, used for PNG images.
    static let png = ContentType(type: "image", subtype: "png")
    
    /// The "image/jpeg" content type, used for JPEG images.
    static let jpeg = ContentType(type: "image", subtype: "jpeg")
    
}
