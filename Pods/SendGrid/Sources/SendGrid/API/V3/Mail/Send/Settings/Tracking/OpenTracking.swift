//
//  OpenTracking.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/16/17.
//

import Foundation

/// The `OpenTracking` class is used to toggle the open tracking setting for an
/// email.
public struct OpenTracking: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// A bool indicating if the setting should be toggled on or off.
    public let enable: Bool
    
    /// An optional tag to specify where to place the open tracking pixel.
    public let substitutionTag: String?
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the setting with a location to put the open tracking pixel
    /// at.
    ///
    /// If the open tracking setting is enabled by default on your SendGrid
    /// account and you want to disable it for this specific email, you should
    /// use the `.off` case.
    ///
    /// - Parameter location:   The location to put the open tracking pixel at
    ///                         in the email. If you want to turn the setting
    ///                         off, use the `.off` case.
    public init(location: Location) {
        switch location {
        case .off:
            self.enable = false
            self.substitutionTag = nil
        case .bottom:
            self.enable = true
            self.substitutionTag = nil
        case .at(let tag):
            self.enable = true
            self.substitutionTag = tag
        }
    }
    
}

/// Encodable conformance
public extension OpenTracking {
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case enable
        case substitutionTag    = "substitution_tag"
    }
    
}

/// Location enum
public extension OpenTracking {
    
    /// The `OpenTracking.Location` enum represents where the open tracking
    /// pixel should be placed in the email.
    ///
    /// If the open tracking setting is enabled by default on your SendGrid
    /// account and you want to disable it for this specific email, you should
    /// use the `.off` case.
    ///
    /// - off:      Disables open tracking for the email.
    /// - bottom:   Places the open tracking pixel at the bottom of the email
    ///             body.
    /// - at:       Places the open tracking pixel at a specified substitution
    ///             tag. For instance, if you wanted to place the open tracking
    ///             pixel at the top of your email, you can specify this case
    ///             with a tag, such as `.at(tag: "%open_tracking%")`, and then
    ///             in the body of your email you can place the text
    ///             "%open_tracking%" at the top. The tag will then be replaced
    ///             with the open tracking pixel.
    public enum Location {
        
        /// Disables open tracking for the email.
        case off
        
        /// Places the open tracking pixel at the bottom of the email body.
        case bottom
        
        /// Places the open tracking pixel at a specified substitution tag. For
        /// instance, if you wanted to place the open tracking pixel at the top
        /// of your email, you can specify this case with a tag, such as
        /// `.at(tag: "%open_tracking%")`, and then in the body of your email
        /// you can place the text "%open_tracking%" at the top. The tag will
        /// then be replaced with the open tracking pixel.
        case at(tag: String)
    }
    
}
