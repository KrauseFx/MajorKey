//
//  ContentDisposition.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/8/17.
//
import Foundation

/// The `ContentDisposition` represents the various content-dispositions an
/// attachment can have.
///
/// - inline: Shows the attachment inline with text.
/// - attachment: Shows the attachment below the text.
public enum ContentDisposition: String, Encodable {
    
    // MARK: - Cases
    //=========================================================================
    
    /// The "inline" disposition, which shows the attachment inline with text.
    case inline
    
    /// The "attachment" disposition, which shows the attachment below the text.
    case attachment
    
}
