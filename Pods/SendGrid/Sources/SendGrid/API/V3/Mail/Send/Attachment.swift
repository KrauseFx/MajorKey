//
//  Attachment.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/13/17.
//

import Foundation

/// The `Attachment` class represents a file to attach to an email.
open class Attachment: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The content, or data, of the attachment.
    public let content: Data
    
    /// The filename of the attachment.
    public let filename: String
    
    /// The content (or MIME) type of the attachment.
    public let type: ContentType?
    
    /// The content-disposition of the attachment specifying how you would like
    /// the attachment to be displayed. For example, "inline" results in the
    /// attached file being displayed automatically within the message while
    /// "attachment" results in the attached file requiring some action to be
    /// taken before it is displayed (e.g. opening or downloading the file).
    public let disposition: ContentDisposition
    
    /// A unique id that you specify for the attachment. This is used when the
    /// disposition is set to "inline" and the attachment is an image, allowing
    /// the file to be displayed within the body of your email. Ex:
    /// `<img src="cid:ii_139db99fdb5c3704"></img>`
    public let contentID: String?
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the attachment.
    ///
    /// - Parameters:
    ///   - filename:       The filename of the attachment.
    ///   - content:        The data of the attachment.
    ///   - disposition:    The content-disposition of the attachment (defaults
    ///                     to `ContentDisposition.Attachment`).
    ///   - type:           The content-type of the attachment.
    ///   - contentID:      The CID of the attachment, used to show the
    ///                     attachments inline with the body of the email.
    public init(filename: String, content: Data, disposition: ContentDisposition = .attachment, type: ContentType? = nil, contentID: String? = nil) {
        self.filename = filename
        self.content = content
        self.disposition = disposition
        self.type = type
        self.contentID = contentID
    }
    
}

/// Encodable conformance.
extension Attachment {
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case content
        case filename
        case type
        case disposition
        case contentID = "content_id"
    }
    
}

/// Validatable conformance.
extension Attachment: Validatable {
    
    /// Validates that the content type of the attachment is correct.
    open func validate() throws {
        try self.type?.validate()
        
        if let id = self.contentID {
            guard Validate.noCLRF(in: id) else { throw Exception.Mail.invalidContentID(id) }
        }
        
        guard Validate.noCLRF(in: self.filename) else {
            throw Exception.Mail.invalidFilename(self.filename)
        }
    }
    
}
