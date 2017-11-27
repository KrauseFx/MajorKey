//
//  ClickTracking.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/16/17.
//

import Foundation


/// The `ClickTracking` class is used to adjust the click tracking setting.
public struct ClickTracking: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// A bool indicating if the setting should be toggled on or off.
    public let enable: Bool
    
    /// A boolean indicating if click tracking should also be applied to links
    /// inside a plain text email.
    public let enableText: Bool?
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the setting encoding a specified section of the email.
    ///
    /// In general, you should use the `.htmlBody` case, as only the HTML body
    /// of an email can have clickable links.
    ///
    /// If, for some reason, you want the URLs in the plain text body of an
    /// email to be tracked as well, you should use the
    /// `.plainTextAndHTMLBodies` case instead. **Be aware**, though, that
    /// having both sections tracked will result in long URLs showing up in the
    /// plain text body.
    ///
    /// If click tracking is normally enabled on your SendGrid account and you
    /// want to disable it for this particular email, use the `.off` case.
    ///
    /// - Parameter section:    The section to track links in, or `.off` to
    ///                         disable the setting.
    public init(section: ClickTracking.Section) {
        switch section {
        case .off:
            self.enable = false
            self.enableText = nil
        case .htmlBody:
            self.enable = true
            self.enableText = false
        case .plainTextAndHTMLBodies:
            self.enable = true
            self.enableText = true
        }
    }
    
}

/// Encodable conformance.
public extension ClickTracking {
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case enable
        case enableText = "enable_text"
    }
    
}

/// Tracking sections
public extension ClickTracking {
    
    /// This enum represents the sections of an email that click tracking should
    /// be applied to. In general, you should use the `.htmlBody` case, as only
    /// the HTML body of an email can have clickable links.
    ///
    /// If, for some reason, you want the URLs in the plain text body of an
    /// email to be tracked as well, you should use the
    /// `.plainTextAndHTMLBodies` case instead. **Be aware**, though, that
    /// having both sections tracked will result in long URLs showing up in the
    /// plain text body.
    ///
    /// If click tracking is normally enabled on your SendGrid account and you
    /// want to disable it for this particular email, use the `.off` case.
    ///
    /// - off:                      If used, the setting will be disabled for
    ///                             this email.
    /// - htmlBody:                 If used, links in the HTML body of the email
    ///                             will be encoded and tracked.
    /// - plainTextAndHTMLBodies:   If used, links in the HTML body and URLs in
    ///                             the plain text body will be encoded and
    ///                             tracked.
    public enum Section {
        
        /// If used, the setting will be disabled for this email.
        case off
        
        /// If used, links in the HTML body of the email will be encoded and
        /// tracked.
        case htmlBody
        
        /// If used, links in the HTML body and URLs in the plain text body will
        /// be encoded and tracked.
        case plainTextAndHTMLBodies
    }
    
}
